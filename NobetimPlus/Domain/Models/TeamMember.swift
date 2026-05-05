import Foundation

enum TeamPermissionRole: String, Codable, CaseIterable, Identifiable, Hashable {
    case admin
    case teamLead
    case owner
    case manager
    case member
    case viewer

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .admin, .owner:
            return "Admin"
        case .teamLead, .manager:
            return "Ekip sorumlusu"
        case .member:
            return "Üye"
        case .viewer:
            return "Görüntüleyici"
        }
    }
}

struct TeamMember: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var role: TeamPermissionRole
    var department: String
    var avatarColor: ShiftColorTag
    var phoneOptional: String?
    var emailOptional: String?
    var workloadScore: Double
    var isOnDutyToday: Bool
    var isOnLeave: Bool
}
