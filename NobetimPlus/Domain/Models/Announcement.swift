import Foundation

struct Announcement: Identifiable, Codable, Hashable {
    var id: UUID
    var teamId: UUID
    var title: String
    var message: String
    var createdBy: UUID
    var createdAt: Date

    init(
        id: UUID = UUID(),
        teamId: UUID,
        title: String,
        message: String,
        createdBy: UUID,
        createdAt: Date = .now
    ) {
        self.id = id
        self.teamId = teamId
        self.title = title
        self.message = message
        self.createdBy = createdBy
        self.createdAt = createdAt
    }
}
