import Foundation
import UserNotifications

@MainActor
final class NotificationManager {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func scheduleShiftReminder(for shift: Shift) {
        guard shift.reminderEnabled else { return }
        let content = UNMutableNotificationContent()
        content.title = "Nöbet hatırlatması"
        content.body = "\(shift.title) \(shift.startDate.formatted(date: .omitted, time: .shortened)) tarihinde başlıyor."
        content.sound = .default

        let triggerDate = Calendar.current.date(byAdding: .hour, value: -2, to: shift.startDate) ?? shift.startDate
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let request = UNNotificationRequest(
            identifier: "shift-\(shift.id.uuidString)",
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        )
        center.add(request)
    }

    func cancelShiftReminder(for shift: Shift) {
        center.removePendingNotificationRequests(withIdentifiers: ["shift-\(shift.id.uuidString)"])
    }

    func scheduleTeamAnnouncement(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        center.add(UNNotificationRequest(identifier: "announcement-\(UUID().uuidString)", content: content, trigger: trigger))
    }
}
