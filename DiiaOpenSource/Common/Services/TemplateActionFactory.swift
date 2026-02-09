import Foundation
import DiiaCommonTypes
import DiiaAuthorization

struct TemplateActionFactory {
    static func refreshTemplateAction(with callback: @escaping Callback) -> (AlertTemplateAction) -> Void {
        return { action in
            ServicesProvider.shared.authService.logout()
            callback()
        }
    }
}

struct RefreshTemplateActionProviderImpl: RefreshTemplateActionProvider {
    func refreshTemplateAction(with callback: @escaping Callback) -> (AlertTemplateAction) -> Void {
        return TemplateActionFactory.refreshTemplateAction(with: callback)
    }
}
