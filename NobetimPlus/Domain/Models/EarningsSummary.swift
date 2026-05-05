import Foundation

struct EarningsSummary: Identifiable, Codable, Hashable {
    var id: String { month }
    var month: String
    var normalHours: Double
    var overtimeHours: Double
    var holidayHours: Double
    var estimatedRevenue: Double
}
