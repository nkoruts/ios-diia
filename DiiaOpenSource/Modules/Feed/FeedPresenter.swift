
import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
import DiiaCommonTypes

protocol FeedAction: BasePresenter {
    func handleEvent(event: ConstructorItemEvent)
}

final class FeedPresenter: FeedAction {

	// MARK: - Properties
    unowned var view: FeedView
    
    private let qrHelper: DiiaQRScannerHelper
    
    private var response: DSConstructorModel?
    
    // MARK: - Init
    init(view: FeedView) {
        self.view = view
        self.qrHelper = DiiaQRScannerHelper(presentingView: view)
    }
    
    // MARK: - Public Methods
    func configureView() {
        let offlineModel = FeedOfflineModeConstructor.buildOfflineModel()
        view.configure(with: offlineModel)
    }
    
    func handleEvent(event: ConstructorItemEvent) {
        guard let parameters = event.actionParameters() else { return }
        handleAction(actionModel: parameters)
    }
    
    func handleAction(actionModel: DSActionParameter) {
        switch actionModel.type {
        case Constants.qrAction:
            CameraAccessChecker.askCameraAccess { [weak self] (granted) in
                if granted, let delegate = self?.qrHelper {
                    self?.view.open(module: QRCodeScannerModule(delegate: delegate))
                }
            }
        default:
            break
        }
    }
}

// MARK: - Constants
extension FeedPresenter {
    private enum Constants {
        static let qrAction = "qr"
    }
}
