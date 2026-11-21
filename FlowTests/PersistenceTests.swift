import Foundation
import SwiftData
import Testing
@testable import Flow

@MainActor
@Test func taskSchedulingPolicyPersistsAndRestoresBothValues() throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let context = ModelContext(container)
    let flexibleTask = Task(title: "Flexible task")
    let fixedTask = Task(title: "Fixed commitment", schedulingPolicy: .fixed)

    context.insert(try TaskPersistenceModel(task: flexibleTask))
    context.insert(try TaskPersistenceModel(task: fixedTask))
    try context.save()

    let readContext = ModelContext(container)
    let restoredTasks = try readContext.fetch(FetchDescriptor<TaskPersistenceModel>())
    let restoredPolicies = try Dictionary(
        uniqueKeysWithValues: restoredTasks.map { model in
            let task = try model.toDomain()
            return (task.id, task.schedulingPolicy)
        }
    )

    #expect(restoredPolicies[flexibleTask.id] == .flexible)
    #expect(restoredPolicies[fixedTask.id] == .fixed)
}

@MainActor
@Test func persistenceRoundTripsPhaseTwoDomainDataAndRelationships() throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let context = ModelContext(container)
    let project = Project(name: "Health")
    let projectModel = ProjectPersistenceModel(project: project)
    let dueDate = try CalendarDate(year: 2026, month: 11, day: 22)
    let preferredDate = try CalendarDate(year: 2026, month: 11, day: 23)
    let task = Task(
        title: "Call the dentist",
        projectID: project.id,
        dueDate: dueDate,
        preferredTime: PreferredTime(date: preferredDate, period: .morning),
        priority: .high,
        estimatedDuration: .seconds(1_800),
        notes: "Ask about the follow-up",
        isCompleted: true,
        schedulingPolicy: .fixed
    )
    let taskModel = try TaskPersistenceModel(task: task, project: projectModel)
    let interval = try ScheduledInterval(
        start: Date(timeIntervalSince1970: 1_000),
        end: Date(timeIntervalSince1970: 2_800)
    )
    let timeBlock = TimeBlock(taskID: task.id, interval: interval)
    let timeBlockModel = try TimeBlockPersistenceModel(timeBlock: timeBlock, task: taskModel)

    context.insert(projectModel)
    context.insert(taskModel)
    context.insert(timeBlockModel)
    try context.save()

    let readContext = ModelContext(container)
    let restoredProjectModel = try #require(readContext.fetch(FetchDescriptor<ProjectPersistenceModel>()).first)
    let restoredTaskModel = try #require(readContext.fetch(FetchDescriptor<TaskPersistenceModel>()).first)
    let restoredTimeBlockModel = try #require(readContext.fetch(FetchDescriptor<TimeBlockPersistenceModel>()).first)
    let restoredTask = try restoredTaskModel.toDomain()
    let restoredTimeBlock = try restoredTimeBlockModel.toDomain()

    #expect(restoredProjectModel.domainValue == project)
    #expect(restoredTask == task)
    #expect(restoredTask.projectID == project.id)
    #expect(restoredTask.dueDate == dueDate)
    #expect(restoredTask.preferredTime == task.preferredTime)
    #expect(restoredTask.priority == .high)
    #expect(restoredTask.estimatedDuration == .seconds(1_800))
    #expect(restoredTask.notes == task.notes)
    #expect(restoredTask.isCompleted)
    #expect(restoredTask.schedulingPolicy == .fixed)
    #expect(restoredTimeBlock == timeBlock)
    #expect(restoredTaskModel.timeBlocks.count == 1)
    #expect(restoredProjectModel.tasks.count == 1)
}

@MainActor
@Test func deletingTaskCascadesToItsTimeBlocks() throws {
    let container = try FlowPersistence.makeContainer(isStoredInMemoryOnly: true)
    let context = ModelContext(container)
    let task = Task(title: "Call the dentist")
    let taskModel = try TaskPersistenceModel(task: task)
    let timeBlock = TimeBlock(
        taskID: task.id,
        interval: try ScheduledInterval(
            start: Date(timeIntervalSince1970: 1_000),
            end: Date(timeIntervalSince1970: 2_800)
        )
    )
    let timeBlockModel = try TimeBlockPersistenceModel(timeBlock: timeBlock, task: taskModel)

    context.insert(taskModel)
    context.insert(timeBlockModel)
    try context.save()
    context.delete(taskModel)
    try context.save()

    #expect(try context.fetch(FetchDescriptor<TimeBlockPersistenceModel>()).isEmpty)
}
