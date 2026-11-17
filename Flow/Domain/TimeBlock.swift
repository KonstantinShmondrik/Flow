import Foundation

struct TimeBlockID: Hashable, Sendable {
    let rawValue: UUID

    init(rawValue: UUID = UUID()) {
        self.rawValue = rawValue
    }
}

struct ScheduledInterval: Equatable, Sendable {
    let start: Date
    let end: Date

    init(start: Date, end: Date) throws {
        guard start < end else {
            throw ScheduledIntervalError.startMustPrecedeEnd
        }

        self.start = start
        self.end = end
    }
}

enum ScheduledIntervalError: Error, Equatable {
    case startMustPrecedeEnd
}

struct TimeBlock: Equatable, Sendable {
    let id: TimeBlockID
    let taskID: TaskID
    var interval: ScheduledInterval

    static func == (lhs: TimeBlock, rhs: TimeBlock) -> Bool {
        lhs.id == rhs.id
    }

    init(id: TimeBlockID = TimeBlockID(), taskID: TaskID, interval: ScheduledInterval) {
        self.id = id
        self.taskID = taskID
        self.interval = interval
    }
}
