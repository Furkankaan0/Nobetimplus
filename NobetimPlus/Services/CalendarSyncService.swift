import EventKit
import Foundation

@MainActor
final class CalendarSyncService {
    private let eventStore = EKEventStore()

    func requestWriteAccess() async -> Bool {
        do {
            if #available(iOS 17.0, *) {
                return try await eventStore.requestWriteOnlyAccessToEvents()
            } else {
                return try await eventStore.requestAccess(to: .event)
            }
        } catch {
            return false
        }
    }

    func makeEventDraft(for shift: Shift) -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.title = shift.title
        event.startDate = shift.startDate
        event.endDate = shift.endDate
        event.notes = shift.notes
        event.location = shift.unit
        event.calendar = eventStore.defaultCalendarForNewEvents
        return event
    }
}
