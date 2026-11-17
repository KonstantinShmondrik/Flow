import Foundation

struct ProjectID: Hashable, Sendable {
    let rawValue: UUID

    init(rawValue: UUID = UUID()) {
        self.rawValue = rawValue
    }
}

struct Project: Equatable, Sendable {
    let id: ProjectID
    var name: String

    init(id: ProjectID = ProjectID(), name: String) {
        self.id = id
        self.name = name
    }
}
