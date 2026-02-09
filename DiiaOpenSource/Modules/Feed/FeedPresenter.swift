
import UIKit
import ReactiveKit
import DiiaNetwork
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
    private let bag = DisposeBag()
    
    private var response: DSConstructorModel?
    private var isFetching = false
    private var needUpdates = true
    
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
        switch event {
        default:
            if let parameters = event.actionParameters() {
                handleAction(actionModel: parameters)
            }
        }
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
    
    // MARK: - Private Methods
    private func setOfflineMode() {
        guard response == nil else { return }

        let offlineModel = FeedOfflineModeConstructor.buildOfflineModel()
        view.configure(with: offlineModel)
    }
    
    // MARK: - Handlers
    private func handleError(error: NetworkError, retryAction: @escaping Callback) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: retryAction,
            didRetry: false,
            in: view
        )
    }
}

// MARK: - Constants
extension FeedPresenter {
    private enum Constants {
        static let messagesAction = "allMessages"
        static let newsAction = "allNews"
        static let newsDetailsAction = "news"
        static let qrAction = "qr"
        static let tickerText = Array(repeating: R.Strings.feed_ticker_label.localized(), count: 3).joined(separator: " • ")
    }
}
