import UIKit
import DiiaNetwork
import DiiaAuthorization

extension AuthorizationContext {
    static func create() -> AuthorizationContext {
        .init(network: .create(),
              storage: AuthorizationStorage(storage: StoreHelper.instance),
              serviceAuthSuccessModule: nil,
              authStateHandler: AuthorizationStateHandler(appRouter: AppRouter.instance, storage: StoreHelper.instance))
    }
}

extension AuthorizationNetworkContext {
    static func create() -> AuthorizationNetworkContext {
        .init(
            session: NetworkConfiguration.default.sessionWithoutInterceptor,
            host: EnvironmentVars.apiHost,
            headers: nil
        )
    }
}
