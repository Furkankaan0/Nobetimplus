import AuthenticationServices
import Foundation

@MainActor
protocol AuthServicing {
    var currentUserIdentifier: String? { get }
    func signOut()
}

@MainActor
final class AuthService: AuthServicing {
    private let userIdentifierKey = "nobetimplus.appleUserIdentifier"

    var currentUserIdentifier: String? {
        KeychainService.read(userIdentifierKey)
    }

    func storeAppleUserIdentifier(_ identifier: String) {
        KeychainService.save(identifier, for: userIdentifierKey)
    }

    func signOut() {
        KeychainService.delete(userIdentifierKey)
    }
}
