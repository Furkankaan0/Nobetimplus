import Foundation

@MainActor
final class TeamService {
    private let repository: TeamRepositoryProtocol

    init(repository: TeamRepositoryProtocol) {
        self.repository = repository
    }

    func teams() throws -> [Team] {
        try repository.fetchTeams()
    }

    func save(_ team: Team) throws {
        try repository.upsert(team)
    }
}
