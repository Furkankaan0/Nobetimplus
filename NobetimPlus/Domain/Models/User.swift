import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var email: String?
    var role: UserRole
    var profession: String
    var department: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        email: String? = nil,
        role: UserRole,
        profession: String,
        department: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.profession = profession
        self.department = department
        self.createdAt = createdAt
    }
}
