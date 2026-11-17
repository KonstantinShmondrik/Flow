import Foundation
import Testing
@testable import Flow

@Test func calendarDateAcceptsValidGregorianDates() throws {
    #expect(try CalendarDate(year: 2026, month: 11, day: 17) == CalendarDate(year: 2026, month: 11, day: 17))
}

@Test func calendarDateAcceptsThirtyAndThirtyOneDayMonths() throws {
    #expect(try CalendarDate(year: 2026, month: 4, day: 30).day == 30)
    #expect(try CalendarDate(year: 2026, month: 1, day: 31).day == 31)
}

@Test func calendarDateValidatesFebruaryForCommonAndLeapYears() throws {
    #expect(try CalendarDate(year: 2026, month: 2, day: 28).day == 28)
    #expect(try CalendarDate(year: 2024, month: 2, day: 29).day == 29)
    #expect(try CalendarDate(year: 2000, month: 2, day: 29).day == 29)
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 1900, month: 2, day: 29) }
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 2023, month: 2, day: 29) }
}

@Test func calendarDateRejectsInvalidComponents() {
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 2026, month: 0, day: 1) }
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 2026, month: 13, day: 1) }
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 2026, month: 1, day: 0) }
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 2026, month: 1, day: 32) }
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 2026, month: 4, day: 31) }
}

@Test func calendarDateRequiresPositiveYear() {
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: 0, month: 1, day: 1) }
    #expect(throws: CalendarDateError.self) { try CalendarDate(year: -1, month: 1, day: 1) }
}

@Test func identifiersKeepTypedValueSemantics() {
    let firstUUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
    let secondUUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2))

    #expect(TaskID(rawValue: firstUUID) == TaskID(rawValue: firstUUID))
    #expect(TaskID(rawValue: firstUUID) != TaskID(rawValue: secondUUID))
    #expect(ProjectID(rawValue: firstUUID) == ProjectID(rawValue: firstUUID))
    #expect(ProjectID(rawValue: firstUUID) != ProjectID(rawValue: secondUUID))
    #expect(TimeBlockID(rawValue: firstUUID) == TimeBlockID(rawValue: firstUUID))
    #expect(TimeBlockID(rawValue: firstUUID) != TimeBlockID(rawValue: secondUUID))
}

@Test func taskEqualityUsesIdentityOnly() {
    let firstID = TaskID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)))
    let differentID = TaskID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2)))

    #expect(Task(id: firstID, title: "First title") == Task(id: firstID, title: "Different title"))
    #expect(Task(id: firstID, title: "First title") != Task(id: differentID, title: "First title"))
}

@Test func projectEqualityUsesIdentityOnly() {
    let firstID = ProjectID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)))
    let differentID = ProjectID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2)))

    #expect(Project(id: firstID, name: "First name") == Project(id: firstID, name: "Different name"))
    #expect(Project(id: firstID, name: "First name") != Project(id: differentID, name: "First name"))
}

@Test func timeBlockEqualityUsesIdentityOnly() throws {
    let firstID = TimeBlockID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)))
    let differentID = TimeBlockID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2)))
    let taskID = TaskID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3)))
    let firstInterval = try ScheduledInterval(
        start: Date(timeIntervalSince1970: 100),
        end: Date(timeIntervalSince1970: 200)
    )
    let secondInterval = try ScheduledInterval(
        start: Date(timeIntervalSince1970: 300),
        end: Date(timeIntervalSince1970: 400)
    )

    #expect(TimeBlock(id: firstID, taskID: taskID, interval: firstInterval) == TimeBlock(id: firstID, taskID: taskID, interval: secondInterval))
    #expect(TimeBlock(id: firstID, taskID: taskID, interval: firstInterval) != TimeBlock(id: differentID, taskID: taskID, interval: firstInterval))
}

@Test func timeBlockIntervalCanChangeWithoutChangingIdentityOrTask() throws {
    let id = TimeBlockID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)))
    let taskID = TaskID(rawValue: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2)))
    let originalInterval = try ScheduledInterval(
        start: Date(timeIntervalSince1970: 100),
        end: Date(timeIntervalSince1970: 200)
    )
    let newInterval = try ScheduledInterval(
        start: Date(timeIntervalSince1970: 300),
        end: Date(timeIntervalSince1970: 400)
    )
    var timeBlock = TimeBlock(id: id, taskID: taskID, interval: originalInterval)

    timeBlock.interval = newInterval

    #expect(timeBlock.id == id)
    #expect(timeBlock.taskID == taskID)
    #expect(timeBlock.interval == newInterval)
}

@Test func preferredDateMayBeLaterThanDueDate() throws {
    let dueDate = try CalendarDate(year: 2026, month: 11, day: 17)
    let preferredDate = try CalendarDate(year: 2026, month: 11, day: 18)
    let task = Task(
        title: "Call the dentist",
        dueDate: dueDate,
        preferredTime: PreferredTime(date: preferredDate, period: .morning)
    )

    #expect(task.dueDate == dueDate)
    #expect(task.preferredTime?.date == preferredDate)
}

@Test func taskSupportsOptionalProjectAndPreferredTime() throws {
    let taskWithoutOptionalValues = Task(title: "Call the dentist")
    #expect(taskWithoutOptionalValues.projectID == nil)
    #expect(taskWithoutOptionalValues.preferredTime == nil)
    #expect(taskWithoutOptionalValues.isCompleted == false)

    let projectID = ProjectID()
    let preferredTime = PreferredTime(
        date: try CalendarDate(year: 2026, month: 11, day: 18),
        period: .morning
    )
    let taskWithOptionalValues = Task(title: "Call the dentist", projectID: projectID, preferredTime: preferredTime)

    #expect(taskWithOptionalValues.projectID == projectID)
    #expect(taskWithOptionalValues.preferredTime == preferredTime)
    #expect(Task(title: "Completed task", isCompleted: true).isCompleted)
}

@Test func nilPreferenceDiffersFromAnytimePreference() {
    let taskWithoutPreference = Task(title: "Call the dentist")
    let anytime = PreferredTime(period: .anytime)
    let taskWithAnytimePreference = Task(title: "Call the dentist", preferredTime: anytime)

    #expect(taskWithoutPreference.preferredTime == nil)
    #expect(taskWithAnytimePreference.preferredTime == anytime)
    #expect(anytime.date == nil)
}

@Test func taskPriorityHasApprovedValues() {
    let priorities: [TaskPriority] = [.low, .normal, .high]

    #expect(priorities.count == 3)
    #expect(priorities[0] == .low)
    #expect(priorities[1] == .normal)
    #expect(priorities[2] == .high)
}

@Test func scheduledIntervalRequiresStartBeforeEnd() throws {
    let start = Date(timeIntervalSince1970: 100)
    let end = Date(timeIntervalSince1970: 200)

    #expect(try ScheduledInterval(start: start, end: end) == ScheduledInterval(start: start, end: end))
    #expect(throws: ScheduledIntervalError.self) { try ScheduledInterval(start: start, end: start) }
    #expect(throws: ScheduledIntervalError.self) { try ScheduledInterval(start: end, end: start) }
}

@Test func taskStoresStandardDurationValue() {
    let duration = Duration.seconds(30)
    let task = Task(title: "Call the dentist", estimatedDuration: duration)

    #expect(task.estimatedDuration == duration)
    #expect(Task(title: "No estimate").estimatedDuration == nil)
}
