import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .today
    @Published var activeSheet: AppSheet?
    @Published var shifts: [Shift] = []
    @Published var teams: [Team] = []
    @Published var profile: UserProfile
    @Published var hasCompletedOnboarding: Bool
    @Published var toastMessage: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    let calculator = WorkCalculationEngine()
    let insightEngine = SmartInsightEngine()
    let notificationManager = NotificationManager()
    let appleSignInManager = AppleSignInManager()
    let authService = AuthService()
    let calendarSyncService = CalendarSyncService()
    let revenueService = RevenueCalculationService()

    private let settingsRepository: SettingsRepositoryProtocol
    private var hasBootstrapped = false
    private let shiftService: ShiftService
    private let teamService: TeamService

    init(
        shiftRepository: ShiftRepositoryProtocol,
        teamRepository: TeamRepositoryProtocol,
        settingsRepository: SettingsRepositoryProtocol
    ) {
        self.settingsRepository = settingsRepository
        self.shiftService = ShiftService(repository: shiftRepository)
        self.teamService = TeamService(repository: teamRepository)
        self.profile = settingsRepository.loadProfile()
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "nobetimplus.hasCompletedOnboarding")
    }

    func bootstrap(force: Bool = false) {
        guard force || !hasBootstrapped else { return }
        hasBootstrapped = true
        isLoading = true
        do {
            shifts = try shiftService.shifts()
            teams = try teamService.teams()
            if shifts.isEmpty {
                try MockData.shifts.forEach { try shiftService.save($0) }
                shifts = try shiftService.shifts()
            }
            errorMessage = nil
        } catch {
            shifts = MockData.shifts
            teams = MockData.teams
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "nobetimplus.hasCompletedOnboarding")
    }

    func addShift(_ shift: Shift) {
        do {
            try shiftService.save(shift)
            shifts = try shiftService.shifts()
            notificationManager.scheduleShiftReminder(for: shift)
            showToast("Nöbet kaydedildi")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteShift(_ shift: Shift) {
        do {
            try shiftService.delete(shift)
            shifts = try shiftService.shifts()
            notificationManager.cancelShiftReminder(for: shift)
            showToast("Nöbet silindi")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateProfile(_ profile: UserProfile) {
        self.profile = profile
        settingsRepository.saveProfile(profile)
    }

    func workSettings() -> WorkCalculationSettings {
        WorkCalculationSettings(
            monthlyNormalHours: profile.monthlyNormalHours,
            overtimeHourlyRate: profile.overtimeHourlyRate,
            holidayHourlyRate: profile.holidayHourlyRate,
            nightWorkMultiplier: profile.nightWorkMultiplier,
            additionalPayment: profile.additionalPayment
        )
    }

    func monthlySummary(month: Date = .now) -> WorkSummary {
        revenueService.monthlySummary(shifts: shifts, month: month, settings: workSettings())
    }

    func earningsSummary(month: Date = .now) -> EarningsSummary {
        revenueService.earningsSummary(shifts: shifts, month: month, settings: workSettings())
    }

    func insights(month: Date = .now) -> [SmartInsight] {
        insightEngine.generateInsights(shifts: shifts, profile: profile, month: month)
    }

    func requestNotifications() {
        Task {
            let granted = await notificationManager.requestAuthorization()
            showToast(granted ? "Bildirimler açıldı" : "Bildirim izni verilmedi")
        }
    }

    func showToast(_ message: String) {
        toastMessage = message
        Task {
            try? await Task.sleep(for: .seconds(2))
            if toastMessage == message {
                toastMessage = nil
            }
        }
    }
}
