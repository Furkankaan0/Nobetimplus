import Foundation

enum ShiftSwapRequestStatus: String, Codable, CaseIterable, Identifiable, Hashable {
    case pending
    case approved
    case rejected
    case cancelled

    var id: String { rawValue }
}

struct ShiftSwapRequest: Identifiable, Codable, Hashable {
    var id: UUID
    var shiftId: UUID
    var requestedBy: UUID
    var requestedTo: UUID
    var status: ShiftSwapRequestStatus
    var message: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        shiftId: UUID,
        requestedBy: UUID,
        requestedTo: UUID,
        status: ShiftSwapRequestStatus = .pending,
        message: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.shiftId = shiftId
        self.requestedBy = requestedBy
        self.requestedTo = requestedTo
        self.status = status
        self.message = message
        self.createdAt = createdAt
    }
}

typealias SwapRequest = ShiftSwapRequest
typealias SwapRequestStatus = ShiftSwapRequestStatus
