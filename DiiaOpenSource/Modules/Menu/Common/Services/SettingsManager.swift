import UIKit
import DiiaCommonTypes
import DiiaUIComponents

class SettingsManager {
    
    static let instance = SettingsManager()
    
    private init() {}
    
    var storeHelper: StoreHelperProtocol = StoreHelper.instance
    
    func openSystemSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        onMainQueue {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
}
