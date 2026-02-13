//
//  EudiDocumentsQRPresenter.swift
//

import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes
import DiiaCommonServices

protocol EudiDocumentsQRAction: BasePresenter {
    func handleCloseAction()
}

final class EudiDocumentsQRPresenter: EudiDocumentsQRAction {
    
    // MARK: - Properties
    unowned var view: EudiDocumentsQRView
    
    private let sessionManager: EudiWalletProximitySessionManager
    
    private let onClose: Callback?
    
    // MARK: - Init
    init(view: EudiDocumentsQRView, onClose: Callback? = nil) {
        self.view = view
        self.onClose = onClose
        self.sessionManager = EudiWalletProximitySessionManager()
        self.sessionManager.delegate = self
    }
    
    // MARK: - Public Methods
    func configureView() {
        sessionManager.startProximityPresentation()
    }
    
    func handleCloseAction() {
        onClose?()
    }

    // MARK: - Navigation
    private func openDisclosureScreen(request: EudiPresentationRequest) {
        view.open(module: EudiWalletProximitySharingModule(
            request: request,
            sessionManager: sessionManager
        ))
    }
    
    // MARK: - Handlers
    private func handleAlert(alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { [weak self] action in
            guard let self = self else { return }
            switch action {
            default:
                self.view.closeModule(animated: true)
            }
        }
    }
    
    private func handleError(error: NetworkError, retryAction: @escaping Callback) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: retryAction,
            didRetry: false,
            in: view
        )
    }
}

// MARK: - ProximitySessionDelegate
extension EudiDocumentsQRPresenter: EudiWalletProximitySessionDelegate {
    public func didGenerateQRCode(_ payload: String) {
        view.configureQR(with: payload)
    }
    
    func didReceiveRequest(_ request: EudiPresentationRequest) {
        openDisclosureScreen(request: request)
    }
    
    public func didFinishPresentation() {
        log("=== FINISH PRESENTATION")
    }
}

// MARK: - Constants
private extension EudiDocumentsQRPresenter {
    enum Constants {
        static let backAction = "back"
    }
}
