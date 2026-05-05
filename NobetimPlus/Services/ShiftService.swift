import Foundation

@MainActor
final class ShiftService {
    private let repository: ShiftRepositoryProtocol

    init(repository: ShiftRepositoryProtocol) {
        self.repository = repository
    }

    func shifts() throws -> [Shift] {
        try repository.fetchShifts()
    }

    func save(_ shift: Shift) throws {
        var mutableShift = shift
        mutableShift.updatedAt = .now
        mutableShift.deletedAt = nil
        mutableShift.syncStatus = .pending
        try repository.upsert(mutableShift)
    }

    func delete(_ shift: Shift) throws {
        try repository.delete(shift)
    }
}
