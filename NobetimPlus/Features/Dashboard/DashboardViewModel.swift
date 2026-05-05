import Foundation

struct DashboardViewModel {
    let profile: UserProfile
    let shifts: [Shift]
    let teams: [Team]
    let summary: WorkSummary
    let insights: [SmartInsight]
    let calculator: WorkCalculationEngine

    var todayShift: Shift? {
        shifts.shifts(on: .now).first
    }

    var teamToday: [TeamMember] {
        teams.first?.members.filter(\.isOnDutyToday) ?? []
    }

    var workloadPercent: Double {
        min(summary.totalWorkHours / max(profile.monthlyNormalHours, 1) * 100, 100)
    }

    var greeting: String {
        let name = profile.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Bugünkü ritmini kur" : "Merhaba, \(name)"
    }

    var nextShiftText: String {
        guard let next = shifts.filter({ $0.startDate > .now }).sorted(by: { $0.startDate < $1.startDate }).first else {
            return "Planlı sıradaki nöbet yok"
        }
        let hours = max(next.startDate.timeIntervalSinceNow / 3600, 0)
        return "Sıradaki nöbete yaklaşık \(Int(hours)) saat kaldı"
    }

    func durationText(for shift: Shift?) -> String {
        guard let shift else { return "0 saat" }
        return String(format: "%.1f saat", calculator.calculateShiftDuration(shift))
    }
}
