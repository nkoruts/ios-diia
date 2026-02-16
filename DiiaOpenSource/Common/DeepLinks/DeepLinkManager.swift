import Foundation
import DiiaCommonTypes
import DiiaCommonServices

class DeepLinkManager {
    var appRouter: AppRouter?
    
    @discardableResult
    func parse(url: URL) -> Bool {
        guard
            let urlString = url
                .absoluteString
                .removingPercentEncoding?
                .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let newUrl = URL(string: urlString),
            let components = URLComponents(url: newUrl, resolvingAgainstBaseURL: true)
        else {
            return false
        }
        
        components.queryItems?.forEach { log($0) }
        
        let walletRouterBuilder = EudiWalletDeeplinkRouteBuilder()
        if let walletRouter = walletRouterBuilder.create(with: urlString) {
            route(with: walletRouter, needPincode: walletRouterBuilder.needAuth)
            return true
        }
        
        guard let routerBuilder = DeeplinksRoutersList.userRouters.first(where: { $0.canCreateRoute(with: components.path) }),
              let deeplinkRouter = routerBuilder.create(pathString: components.path)
        else {
            return false
        }
        
        route(with: deeplinkRouter, needPincode: routerBuilder.needAuth())
        
        return true
    }
    
    private func route(with router: RouterProtocol, needPincode: Bool) {
        appRouter?.performOrDefer(
            action: { view in
                guard let view = view else { return }
                router.route(in: view)
            },
            needPincode: needPincode
        )
    }
}

extension DeepLinkManager: DeepLinkManagerProtocol { }
