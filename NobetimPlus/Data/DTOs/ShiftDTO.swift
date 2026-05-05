import Foundation

struct ShiftDTO: Codable, Hashable {
    var id: UUID
    var userId: UUID?
    var teamId: UUID?
    var title: String
    var startDate: Date
    var endDate: Date
    var department: String
    var unit: String
    var type: String
    var notes: String
    var isHoliday: Bool
    var isOvertime: Bool
    var hourlyRate: Double?
    var createdAt: Date
    var updatedAt: Date
    var deletedAt: Date?
    var syncStatus: String
}
