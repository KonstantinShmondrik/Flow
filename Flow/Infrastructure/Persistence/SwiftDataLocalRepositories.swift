import Foundation
import SwiftData

@ModelActor
actor SwiftDataLocalRepositories: TaskRepository, ProjectRepository {
    func task(for id: TaskID) async throws -> Task? {
        try withRepositoryErrors {
            guard let model = try taskModel(for: id) else { return nil }
            return try model.toDomain()
        }
    }

    func tasks() async throws -> [Task] {
        try withRepositoryErrors {
            try modelContext.fetch(FetchDescriptor<TaskPersistenceModel>()).map { try $0.toDomain() }
        }
    }

    func save(_ task: Task) async throws {
        try withRepositoryErrors {
            let project = try task.projectID.map { id in
                guard let model = try projectModel(for: id) else {
                    throw RepositoryError.projectNotFound(id)
                }
                return model
            }

            if let existing = try taskModel(for: task.id) {
                existing.update(from: task, project: project)
            } else {
                modelContext.insert(try TaskPersistenceModel(task: task, project: project))
            }
            try modelContext.save()
        }
    }

    func deleteTask(id: TaskID) async throws {
        try withRepositoryErrors {
            guard let model = try taskModel(for: id) else {
                throw RepositoryError.taskNotFound(id)
            }
            modelContext.delete(model)
            try modelContext.save()
        }
    }

    func timeBlocks(for taskID: TaskID) async throws -> [TimeBlock] {
        try withRepositoryErrors {
            guard let task = try taskModel(for: taskID) else {
                throw RepositoryError.taskNotFound(taskID)
            }
            return try task.timeBlocks.map { try $0.toDomain() }
        }
    }

    func save(_ timeBlock: TimeBlock) async throws {
        try withRepositoryErrors {
            guard let task = try taskModel(for: timeBlock.taskID) else {
                throw RepositoryError.taskNotFound(timeBlock.taskID)
            }

            if let existing = try timeBlockModel(for: timeBlock.id) {
                guard existing.task.id == timeBlock.taskID.rawValue else {
                    throw RepositoryError.timeBlockTaskMismatch
                }
                existing.start = timeBlock.interval.start
                existing.end = timeBlock.interval.end
            } else {
                modelContext.insert(try TimeBlockPersistenceModel(timeBlock: timeBlock, task: task))
            }
            try modelContext.save()
        }
    }

    func deleteTimeBlock(id: TimeBlockID) async throws {
        try withRepositoryErrors {
            guard let model = try timeBlockModel(for: id) else {
                throw RepositoryError.timeBlockNotFound(id)
            }
            modelContext.delete(model)
            try modelContext.save()
        }
    }

    func project(for id: ProjectID) async throws -> Project? {
        try withRepositoryErrors {
            try projectModel(for: id)?.domainValue
        }
    }

    func projects() async throws -> [Project] {
        try withRepositoryErrors {
            try modelContext.fetch(FetchDescriptor<ProjectPersistenceModel>()).map(\.domainValue)
        }
    }

    func save(_ project: Project) async throws {
        try withRepositoryErrors {
            if let existing = try projectModel(for: project.id) {
                existing.name = project.name
            } else {
                modelContext.insert(ProjectPersistenceModel(project: project))
            }
            try modelContext.save()
        }
    }

    func deleteProject(id: ProjectID) async throws {
        try withRepositoryErrors {
            guard let model = try projectModel(for: id) else {
                throw RepositoryError.projectNotFound(id)
            }
            guard model.tasks.isEmpty else {
                throw RepositoryError.projectHasTasks(id)
            }
            modelContext.delete(model)
            try modelContext.save()
        }
    }

    private func taskModel(for id: TaskID) throws -> TaskPersistenceModel? {
        let rawID = id.rawValue
        var descriptor = FetchDescriptor<TaskPersistenceModel>(predicate: #Predicate { $0.id == rawID })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func projectModel(for id: ProjectID) throws -> ProjectPersistenceModel? {
        let rawID = id.rawValue
        var descriptor = FetchDescriptor<ProjectPersistenceModel>(predicate: #Predicate { $0.id == rawID })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func timeBlockModel(for id: TimeBlockID) throws -> TimeBlockPersistenceModel? {
        let rawID = id.rawValue
        var descriptor = FetchDescriptor<TimeBlockPersistenceModel>(predicate: #Predicate { $0.id == rawID })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func withRepositoryErrors<T>(_ operation: () throws -> T) throws -> T {
        do {
            return try operation()
        } catch let error as RepositoryError {
            modelContext.rollback()
            throw error
        } catch is PersistenceMappingError {
            modelContext.rollback()
            throw RepositoryError.invalidStoredData
        } catch {
            modelContext.rollback()
            throw RepositoryError.persistenceFailure
        }
    }
}
