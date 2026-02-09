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
        .init(session: NetworkConfiguration.default.sessionWithoutInterceptor,
              host: EnvironmentVars.apiHost,
              headers: ["App-Version": AppConstants.App.appVersion,
                        "Platform-Type": AppConstants.App.platform,
                        "Platform-Version": AppConstants.App.iOSVersion,
                        "mobile_uid": AppConstants.App.mobileUID,
                        "User-Agent": AppConstants.App.userAgent]
        )
    }
}

// TODO: - REMOVE AnalyticsAuthorizationAdapter
final class AnalyticsAuthorizationAdapter: AnalyticsAuthorizationHandler {
    
    func trackSuccessForTarget(target: AuthTarget) { }
    
    func trackFailForTarget(target: AuthTarget, error: NetworkError) { }
}
