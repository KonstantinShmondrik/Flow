import Foundation
import SwiftData

enum FlowPersistence {
    static func makeContainer(isStoredInMemoryOnly: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            ProjectPersistenceModel.self,
            TaskPersistenceModel.self,
            TimeBlockPersistenceModel.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )

        return try ModelContainer(for: schema, configurations: [configuration])
    }
}

@Model
final class ProjectPersistenceModel {
    var id: UUID
    var name: String

    @Relationship(deleteRule: .deny, inverse: \TaskPersistenceModel.project)
    var tasks: [TaskPersistenceModel] = []

    init(project: Project) {
        id = project.id.rawValue
        name = project.name
    }

    var domainValue: Project {
        Project(id: ProjectID(rawValue: id), name: name)
    }
}

@Model
final class TaskPersistenceModel {
    var id: UUID
    var title: String
    var dueDateYear: Int?
    var dueDateMonth: Int?
    var dueDateDay: Int?
    var preferredDateYear: Int?
    var preferredDateMonth: Int?
    var preferredDateDay: Int?
    var preferredTimePeriod: String?
    var priority: String?
    var estimatedDurationSeconds: Int64?
    var estimatedDurationAttoseconds: Int64?
    var notes: String?
    var isCompleted: Bool
    var schedulingPolicy: String

    var project: ProjectPersistenceModel?

    @Relationship(deleteRule: .cascade, inverse: \TimeBlockPersistenceModel.task)
    var timeBlocks: [TimeBlockPersistenceModel] = []

    init(task: Task, project: ProjectPersistenceModel? = nil) throws {
        if let projectID = task.projectID {
            guard project?.id == projectID.rawValue else {
                throw PersistenceMappingError.projectReferenceMismatch
            }
        } else if project != nil {
            throw PersistenceMappingError.projectReferenceMismatch
        }

        id = task.id.rawValue
        title = task.title
        dueDateYear = task.dueDate?.year
        dueDateMonth = task.dueDate?.month
        dueDateDay = task.dueDate?.day
        preferredDateYear = task.preferredTime?.date?.year
        preferredDateMonth = task.preferredTime?.date?.month
        preferredDateDay = task.preferredTime?.date?.day
        preferredTimePeriod = task.preferredTime.map(Self.encode)
        priority = task.priority.map(Self.encode)
        if let estimatedDuration = task.estimatedDuration {
            let components = estimatedDuration.components
            estimatedDurationSeconds = components.seconds
            estimatedDurationAttoseconds = components.attoseconds
        } else {
            estimatedDurationSeconds = nil
            estimatedDurationAttoseconds = nil
        }
        notes = task.notes
        isCompleted = task.isCompleted
        schedulingPolicy = Self.encode(task.schedulingPolicy)
        self.project = project
    }

    func toDomain() throws -> Task {
        let dueDate = try Self.decodeDate(year: dueDateYear, month: dueDateMonth, day: dueDateDay)
        let preferredDate = try Self.decodeDate(
            year: preferredDateYear,
            month: preferredDateMonth,
            day: preferredDateDay
        )

        let preferredTime: PreferredTime?
        if let preferredTimePeriod {
            preferredTime = PreferredTime(
                date: preferredDate,
                period: try Self.decodePreferredTimePeriod(preferredTimePeriod)
            )
        } else {
            guard preferredDate == nil else {
                throw PersistenceMappingError.invalidStoredPreferredTime
            }
            preferredTime = nil
        }

        let estimatedDuration: Duration?
        switch (estimatedDurationSeconds, estimatedDurationAttoseconds) {
        case let (seconds?, attoseconds?):
            estimatedDuration = Duration(secondsComponent: seconds, attosecondsComponent: attoseconds)
        case (nil, nil):
            estimatedDuration = nil
        default:
            throw PersistenceMappingError.invalidStoredDuration
        }

        return Task(
            id: TaskID(rawValue: id),
            title: title,
            projectID: project.map { ProjectID(rawValue: $0.id) },
            dueDate: dueDate,
            preferredTime: preferredTime,
            priority: try priority.map(Self.decodePriority),
            estimatedDuration: estimatedDuration,
            notes: notes,
            isCompleted: isCompleted,
            schedulingPolicy: try Self.decodeSchedulingPolicy(schedulingPolicy)
        )
    }

    private static func encode(_ policy: SchedulingPolicy) -> String {
        switch policy {
        case .flexible: "flexible"
        case .fixed: "fixed"
        }
    }

    private static func decodeSchedulingPolicy(_ value: String) throws -> SchedulingPolicy {
        switch value {
        case "flexible": .flexible
        case "fixed": .fixed
        default: throw PersistenceMappingError.invalidStoredSchedulingPolicy
        }
    }

    private static func encode(_ priority: TaskPriority) -> String {
        switch priority {
        case .low: "low"
        case .normal: "normal"
        case .high: "high"
        }
    }

    private static func decodePriority(_ value: String) throws -> TaskPriority {
        switch value {
        case "low": .low
        case "normal": .normal
        case "high": .high
        default: throw PersistenceMappingError.invalidStoredPriority
        }
    }

    private static func encode(_ preferredTime: PreferredTime) -> String {
        switch preferredTime.period {
        case .anytime: "anytime"
        case .morning: "morning"
        case .afternoon: "afternoon"
        case .evening: "evening"
        }
    }

    private static func decodePreferredTimePeriod(_ value: String) throws -> PreferredTimePeriod {
        switch value {
        case "anytime": .anytime
        case "morning": .morning
        case "afternoon": .afternoon
        case "evening": .evening
        default: throw PersistenceMappingError.invalidStoredPreferredTime
        }
    }

    private static func decodeDate(year: Int?, month: Int?, day: Int?) throws -> CalendarDate? {
        switch (year, month, day) {
        case let (year?, month?, day?):
            do {
                return try CalendarDate(year: year, month: month, day: day)
            } catch {
                throw PersistenceMappingError.invalidStoredCalendarDate
            }
        case (nil, nil, nil):
            return nil
        default:
            throw PersistenceMappingError.invalidStoredCalendarDate
        }
    }
}

@Model
final class TimeBlockPersistenceModel {
    var id: UUID
    var start: Date
    var end: Date
    var task: TaskPersistenceModel

    init(timeBlock: TimeBlock, task: TaskPersistenceModel) throws {
        guard timeBlock.taskID.rawValue == task.id else {
            throw PersistenceMappingError.taskReferenceMismatch
        }

        id = timeBlock.id.rawValue
        start = timeBlock.interval.start
        end = timeBlock.interval.end
        self.task = task
    }

    func toDomain() throws -> TimeBlock {
        do {
            return TimeBlock(
                id: TimeBlockID(rawValue: id),
                taskID: TaskID(rawValue: task.id),
                interval: try ScheduledInterval(start: start, end: end)
            )
        } catch {
            throw PersistenceMappingError.invalidStoredInterval
        }
    }
}

enum PersistenceMappingError: Error, Equatable {
    case projectReferenceMismatch
    case taskReferenceMismatch
    case invalidStoredCalendarDate
    case invalidStoredPreferredTime
    case invalidStoredPriority
    case invalidStoredSchedulingPolicy
    case invalidStoredDuration
    case invalidStoredInterval
}
