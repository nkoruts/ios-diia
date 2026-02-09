import UIKit
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices
import DiiaUIComponents

class AppConfigurator {
    static var storeHelper: StoreHelperProtocol = StoreHelper.instance

    static func configureApp() {
        if storeHelper.getValue(forKey: .hasAppBeenLaunchedBefore) != true {
            storeHelper.clearAllData()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        FontBook.mainFont = AppMainFont()
        FontBook.headingFont = AppHeadingFont()
        UIComponentsConfiguration.shared.setup(imageNameProvider: DSImageNameResolver.instance, imageLoader: nil, urlOpener: URLOpenerImpl(), logger: PrintLogger())

        let deepLinkManager = DeepLinkManager()
        deepLinkManager.appRouter = AppRouter.instance
        let routingHandler = RoutingHandler(appRouter: AppRouter.instance)
        TemplateHandler.setup(context: .init(router: routingHandler,
                                             deepLink: deepLinkManager,
                                             communicationHelper: URLOpenerImpl()))
    }
}

class RoutingHandler: RoutingHandlerProtocol {
    private let appRouter: AppRouter

    internal init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func performPresenting(action: @escaping (BaseView?) -> Void) {
        appRouter.performOrDefer(action: action, needPincode: false)
    }
    func popToPublicServices() {
        appRouter.popToTab(with: .publicService)
    }
    
    func popToFeed() {
        appRouter.popToTab(with: .feed)
    }
    
    func popToDocuments() {
        appRouter.popToTab(with: .documents(type: nil))
    }
}

