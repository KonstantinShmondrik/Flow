import Foundation
import SwiftData
import Testing
@testable import Flow

@Test func taskAndProjectRepositoriesPersistAndUpdateDomainValues() async throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let repository = SwiftDataLocalRepositories(modelContainer: container)
    let project = Project(name: "Health")
    let task = Task(title: "Call the dentist", projectID: project.id)

    try await repository.save(project)
    try await repository.save(task)

    #expect(try await repository.project(for: project.id) == project)
    #expect(try await repository.projects() == [project])
    #expect(try await repository.task(for: task.id) == task)
    #expect(try await repository.tasks() == [task])

    var updatedTask = task
    updatedTask.title = "Call the new dentist"
    updatedTask.isCompleted = true
    updatedTask.schedulingPolicy = .fixed
    try await repository.save(updatedTask)

    let restoredTask = try #require(await repository.task(for: task.id))
    #expect(restoredTask.title == "Call the new dentist")
    #expect(restoredTask.isCompleted)
    #expect(restoredTask.schedulingPolicy == .fixed)
    #expect(try await repository.tasks().count == 1)
}

@MainActor
@Test func taskRepositoryPersistsAndUpdatesTimeBlocksAndDeletesThemWithTask() async throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let repository = SwiftDataLocalRepositories(modelContainer: container)
    let task = Task(title: "Call the dentist")
    let interval = try ScheduledInterval(
        start: Date(timeIntervalSince1970: 1_000),
        end: Date(timeIntervalSince1970: 2_800)
    )
    let timeBlock = TimeBlock(taskID: task.id, interval: interval)

    try await repository.save(task)
    try await repository.save(timeBlock)
    #expect(try await repository.timeBlocks(for: task.id) == [timeBlock])

    let anotherTask = Task(title: "Visit the pharmacy")
    try await repository.save(anotherTask)
    let reassignedTimeBlock = TimeBlock(id: timeBlock.id, taskID: anotherTask.id, interval: interval)
    do {
        try await repository.save(reassignedTimeBlock)
        Issue.record("Expected a persisted TimeBlock to keep its original Task relationship")
    } catch let error as RepositoryError {
        #expect(error == .timeBlockTaskMismatch)
    }
    #expect(try await repository.timeBlocks(for: task.id) == [timeBlock])
    #expect(try await repository.timeBlocks(for: anotherTask.id).isEmpty)

    var updatedTimeBlock = timeBlock
    updatedTimeBlock.interval = try ScheduledInterval(
        start: Date(timeIntervalSince1970: 3_000),
        end: Date(timeIntervalSince1970: 4_000)
    )
    try await repository.save(updatedTimeBlock)
    let restoredTimeBlocks = try await repository.timeBlocks(for: task.id)
    #expect(restoredTimeBlocks.count == 1)
    #expect(restoredTimeBlocks.first?.id == timeBlock.id)
    #expect(restoredTimeBlocks.first?.interval == updatedTimeBlock.interval)

    try await repository.deleteTimeBlock(id: timeBlock.id)
    #expect(try await repository.timeBlocks(for: task.id).isEmpty)

    try await repository.save(timeBlock)
    try await repository.deleteTask(id: task.id)
    #expect(try await repository.task(for: task.id) == nil)
    let context = ModelContext(container)
    #expect(try context.fetch(FetchDescriptor<TimeBlockPersistenceModel>()).isEmpty)
}

@MainActor
@Test func repositoryTranslatesInvalidStoredDomainData() async throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let context = ModelContext(container)
    let taskModel = try TaskPersistenceModel(task: Task(title: "Call the dentist"))
    taskModel.schedulingPolicy = "unknown"
    context.insert(taskModel)
    try context.save()

    let repository = SwiftDataLocalRepositories(modelContainer: container)
    do {
        _ = try await repository.task(for: TaskID(rawValue: taskModel.id))
        Issue.record("Expected invalid persisted data to be translated")
    } catch let error as RepositoryError {
        #expect(error == .invalidStoredData)
    }
}

@Test func projectDeletionIsRefusedUntilReferencingTasksAreDeleted() async throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let repository = SwiftDataLocalRepositories(modelContainer: container)
    let project = Project(name: "Health")
    let task = Task(title: "Call the dentist", projectID: project.id)

    try await repository.save(project)
    try await repository.save(task)

    do {
        try await repository.deleteProject(id: project.id)
        Issue.record("Expected project deletion to be refused while a Task references it")
    } catch let error as RepositoryError {
        #expect(error == .projectHasTasks(project.id))
    }

    #expect(try await repository.project(for: project.id) == project)
    try await repository.deleteTask(id: task.id)

    let renamedProject = Project(id: project.id, name: "Personal health")
    try await repository.save(renamedProject)
    #expect(try await repository.project(for: project.id)?.name == "Personal health")
    try await repository.deleteProject(id: project.id)
    #expect(try await repository.project(for: project.id) == nil)
    #expect(try await repository.projects().isEmpty)
}

@Test func repositoriesReportMissingReferencesAndEntitiesExplicitly() async throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let repository = SwiftDataLocalRepositories(modelContainer: container)
    let missingProjectID = ProjectID()
    let missingTaskID = TaskID()
    let missingTimeBlockID = TimeBlockID()

    do {
        try await repository.save(Task(title: "Orphan", projectID: missingProjectID))
        Issue.record("Expected missing Project reference to be rejected")
    } catch let error as RepositoryError {
        #expect(error == .projectNotFound(missingProjectID))
    }

    let timeBlock = TimeBlock(
        taskID: missingTaskID,
        interval: try ScheduledInterval(
            start: Date(timeIntervalSince1970: 1_000),
            end: Date(timeIntervalSince1970: 2_000)
        )
    )
    do {
        try await repository.save(timeBlock)
        Issue.record("Expected missing Task reference to be rejected")
    } catch let error as RepositoryError {
        #expect(error == .taskNotFound(missingTaskID))
    }

    do {
        try await repository.deleteTask(id: missingTaskID)
        Issue.record("Expected deleting a missing Task to fail")
    } catch let error as RepositoryError {
        #expect(error == .taskNotFound(missingTaskID))
    }

    do {
        try await repository.deleteProject(id: missingProjectID)
        Issue.record("Expected deleting a missing Project to fail")
    } catch let error as RepositoryError {
        #expect(error == .projectNotFound(missingProjectID))
    }

    do {
        try await repository.deleteTimeBlock(id: missingTimeBlockID)
        Issue.record("Expected deleting a missing TimeBlock to fail")
    } catch let error as RepositoryError {
        #expect(error == .timeBlockNotFound(missingTimeBlockID))
    }
}
