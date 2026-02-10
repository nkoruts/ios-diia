import Foundation
import DiiaAuthorization

final class ServicesProvider {
    static var shared: ServicesProvider = ServicesProvider()

    let authService: AuthorizationService = .init(context: .create())

    private init() { }
}
