import UIKit
import DiiaMVPModule
import DiiaAuthorizationPinCode

protocol SettingsAction: BasePresenter {
    func onBackTapped()
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> TitleCellViewModel?
}

final class SettingsPresenter: SettingsAction {
    
    // MARK: - Properties
    unowned var view: SettingsView
    private let settingsManager = SettingsManager.instance
    private var settings: [TitleCellViewModel] = []
    
    // MARK: - Init
    init(view: SettingsView) {
        self.view = view
        prepareSettings()
    }
    
    private func prepareSettings() {
        self.settings = [
            TitleCellViewModel(
                title: R.Strings.settings_docs_order.localized(),
                iconName: R.image.orderIcon.name,
                action: { [weak view] in view?.open(module: DocumentsReorderingModule()) }
            ),
            TitleCellViewModel(
                title: R.Strings.menu_change_pin.localized(),
                iconName: R.image.menuChangePincode.name,
                action: { [weak view] in
                    let module = ChangePincodeModule(
                        pinCodeLength: AppConstants.defaultPinCodeLength,
                        context: ChangePincodeModuleContext.create()
                    )
                    view?.open(module: module)
                }
                
            )
        ]
    }
    
    // MARK: - SettingsAction
    func onBackTapped() {
        view.closeModule(animated: true)
    }
    
    func numberOfItems() -> Int {
        return settings.count
    }
    
    func item(at indexPath: IndexPath) -> TitleCellViewModel? {
        guard settings.indices.contains(indexPath.row) else { return nil }
        
        return settings[indexPath.row]
    }
}
