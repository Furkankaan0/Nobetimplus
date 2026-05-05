import Foundation

struct RevenueCalculationService {
    private let calculator: WorkCalculationEngine

    init(calculator: WorkCalculationEngine = WorkCalculationEngine()) {
        self.calculator = calculator
    }

    func monthlySummary(shifts: [Shift], month: Date, settings: WorkCalculationSettings) -> WorkSummary {
        calculator.makeMonthlySummary(shifts: shifts, month: month, settings: settings)
    }

    func earningsSummary(shifts: [Shift], month: Date, settings: WorkCalculationSettings) -> EarningsSummary {
        let summary = monthlySummary(shifts: shifts, month: month, settings: settings)
        return EarningsSummary(
            month: summary.monthIdentifier,
            normalHours: summary.normalShiftHours,
            overtimeHours: summary.overtimeHours,
            holidayHours: summary.officialHolidayHours,
            estimatedRevenue: summary.estimatedTotalExtraIncome
        )
    }
}
