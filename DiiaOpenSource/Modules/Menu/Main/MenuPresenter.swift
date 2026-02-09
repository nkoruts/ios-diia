import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaAuthorization

protocol MenuAction: BasePresenter {
    func logout()
}

final class MenuPresenter: MenuAction {
    private unowned var view: MenuView
    
    init(view: MenuView) {
        self.view = view
    }
    
    func configureView() {
        view.setTitle(title: R.Strings.main_screen_menu.localized())
        setupSettings()
    }
    
    func logout() {
        ServicesProvider.shared.authService.logout()
    }
    
    // MARK: - Configuration
    private func setupSettings() {
        view.clearStack()
        view.addList(list: .init(items: messagesSection()))
    }
}

private extension MenuPresenter {
    func messagesSection() -> [DSListItemViewModel] {
        return [
            DSListItemViewModel(
                leftSmallIcon: R.image.settings.image,
                title: R.Strings.menu_title_settings.localized(),
                onClick: { [weak self] in
                    self?.view.open(module: SettingsModule())
                })
        ]
    }
}
