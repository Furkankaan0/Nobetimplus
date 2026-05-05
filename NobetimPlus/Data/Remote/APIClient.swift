import Foundation

struct APIClient {
    var baseURL: URL?

    func send<T: Encodable, U: Decodable>(_ value: T, path: String, method: String = "POST") async throws -> U {
        // Backend MVP dışında. RemoteDataSource protokolleri bu katmana bağlanmaya hazır.
        _ = value
        _ = path
        _ = method
        throw URLError(.unsupportedURL)
    }

    func get<U: Decodable>(_ path: String) async throws -> U {
        _ = path
        throw URLError(.unsupportedURL)
    }
}
