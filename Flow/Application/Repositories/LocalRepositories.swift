import Foundation

protocol TaskRepository: Sendable {
    func task(for id: TaskID) async throws -> Task?
    func tasks() async throws -> [Task]
    func save(_ task: Task) async throws
    func deleteTask(id: TaskID) async throws

    func timeBlocks(for taskID: TaskID) async throws -> [TimeBlock]
    func save(_ timeBlock: TimeBlock) async throws
    func deleteTimeBlock(id: TimeBlockID) async throws
}

protocol ProjectRepository: Sendable {
    func project(for id: ProjectID) async throws -> Project?
    func projects() async throws -> [Project]
    func save(_ project: Project) async throws
    func deleteProject(id: ProjectID) async throws
}

enum RepositoryError: Error, Equatable, Sendable {
    case taskNotFound(TaskID)
    case projectNotFound(ProjectID)
    case timeBlockNotFound(TimeBlockID)
    case projectHasTasks(ProjectID)
    case timeBlockTaskMismatch
    case invalidStoredData
    case persistenceFailure
}
