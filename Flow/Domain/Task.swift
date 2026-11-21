import Foundation

struct TaskID: Hashable, Sendable {
    let rawValue: UUID

    init(rawValue: UUID = UUID()) {
        self.rawValue = rawValue
    }
}

enum TaskPriority: Equatable, Sendable {
    case low
    case normal
    case high
}

enum SchedulingPolicy: Equatable, Sendable {
    case flexible
    case fixed
}

enum PreferredTimePeriod: Equatable, Sendable {
    case anytime
    case morning
    case afternoon
    case evening
}

struct PreferredTime: Equatable, Sendable {
    let date: CalendarDate?
    let period: PreferredTimePeriod

    init(date: CalendarDate? = nil, period: PreferredTimePeriod) {
        self.date = date
        self.period = period
    }
}

struct Task: Equatable, Sendable {
    let id: TaskID
    var title: String
    var projectID: ProjectID?
    var dueDate: CalendarDate?
    var preferredTime: PreferredTime?
    var priority: TaskPriority?
    var estimatedDuration: Duration?
    var notes: String?
    var isCompleted: Bool
    var schedulingPolicy: SchedulingPolicy

    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }

    init(
        id: TaskID = TaskID(),
        title: String,
        projectID: ProjectID? = nil,
        dueDate: CalendarDate? = nil,
        preferredTime: PreferredTime? = nil,
        priority: TaskPriority? = nil,
        estimatedDuration: Duration? = nil,
        notes: String? = nil,
        isCompleted: Bool = false,
        schedulingPolicy: SchedulingPolicy = .flexible
    ) {
        self.id = id
        self.title = title
        self.projectID = projectID
        self.dueDate = dueDate
        self.preferredTime = preferredTime
        self.priority = priority
        self.estimatedDuration = estimatedDuration
        self.notes = notes
        self.isCompleted = isCompleted
        self.schedulingPolicy = schedulingPolicy
    }
}
