import UIKit
import DiiaNetwork
import DiiaAuthorization

extension AuthorizationContext {
    static func create() -> AuthorizationContext {
        .init(network: .create(),
              storage: AuthorizationStorage(storage: StoreHelper.instance),
              serviceAuthSuccessModule: nil,
              refreshTemplateActionProvider: RefreshTemplateActionProviderImpl(),
              authStateHandler: AuthorizationStateHandler(appRouter: AppRouter.instance, storage: StoreHelper.instance),
              userAuthorizationErrorRouter: UserAuthorizationErrorRouter(),
              analyticsHandler: AnalyticsAuthorizationAdapter())
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

// TODO: - REMOVE AnalyticsAuthorizationAdapter
final class AnalyticsAuthorizationAdapter: AnalyticsAuthorizationHandler {
    
    func trackSuccessForTarget(target: AuthTarget) { }
    
    func trackFailForTarget(target: AuthTarget, error: NetworkError) { }
}
