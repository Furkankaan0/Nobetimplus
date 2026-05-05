import Foundation

protocol RemoteShiftDataSource {
    func fetchShifts(updatedAfter date: Date?) async throws -> [ShiftDTO]
    func pushShift(_ shift: ShiftDTO) async throws -> ShiftDTO
    func deleteShift(id: UUID, deletedAt: Date) async throws
}

protocol RemoteTeamDataSource {
    func fetchTeams() async throws -> [Team]
    func pushTeam(_ team: Team) async throws -> Team
}

protocol RemoteAnnouncementDataSource {
    func fetchAnnouncements(teamId: UUID) async throws -> [Announcement]
    func createAnnouncement(_ announcement: Announcement) async throws -> Announcement
}

protocol RemoteSwapRequestDataSource {
    func fetchSwapRequests(teamId: UUID) async throws -> [ShiftSwapRequest]
    func createSwapRequest(_ request: ShiftSwapRequest) async throws -> ShiftSwapRequest
    func updateSwapRequestStatus(id: UUID, status: ShiftSwapRequestStatus) async throws -> ShiftSwapRequest
}
