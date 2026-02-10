import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaAuthorization
import DiiaUIComponents

// TODO: - REMOVE
struct UserAuthorizationErrorRouter: RouterExtendedProtocol {

    private var callback: Callback {{
        let module = HorizontalActionSheetModule(title: R.Strings.menu_support.localized(), actions: [])
        AppRouter.instance.currentView()?.showChild(module: module)
    }}

    // TODO: - REMOVE MOBILE UID
    var module: AuthorizationErrorModule {
        AuthorizationErrorModule(
            errorInfo: .userAuth(with: callback),
            mobileUID: { "" },
            logout: { ServicesProvider.shared.authService.logout() }
        )
    }

    // MARK: - RouterProtocol
    func route(in view: BaseView) {
        view.open(module: module)
    }

    // MARK: - RouterExtendedProtocol
    func route(in view: BaseView, replace: Bool, animated: Bool) {
        if replace {
            view.replace(with: module, animated: animated)
        } else {
            view.open(module: module)
        }
    }
}
