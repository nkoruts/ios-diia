//
//  EudiWalletOnboardingPresenter.swift
//

import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import EudiWalletKit
import DiiaCommonTypes
import DiiaUIComponents
import DiiaAuthorization
import DiiaCommonServices
import DiiaAuthorizationPinCode

final class EudiWalletOnboardingPresenter: ConstructorScreenPresenter, ContextMenuConfigurable {
    
    // MARK: - Properties
    unowned var view: ConstructorScreenViewProtocol
    
    private var contextMenuProvider: ContextMenuProviderProtocol
    private let apiClient: EWalletAPIClientProtocol
    private let walletController: EudiWalletKitProtocol
    private let flowCoordinator: FlowCoordinatorProtocol
    private let bag = DisposeBag()
    private var didRetry = false
    
    private let documentType: EudiWalletDocumentType
    private var buttonViewModel: DSLoadingButtonViewModel?
    
    // MARK: - Init
    init(
        documentType: EudiWalletDocumentType,
        view: ConstructorScreenViewProtocol,
        flowCoordinator: FlowCoordinatorProtocol,
        contextMenuProvider: ContextMenuProviderProtocol
    ) {
        self.documentType = documentType
        self.view = view
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        
        self.apiClient = EWalletAPIClient()
        self.walletController = EudiWalletKitController.instance
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setupBackground(.image(R.image.light_background.image ?? UIImage()))
            
//        fetchScreen()
        activateEudiWallet()
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func handleEvent(event: ConstructorItemEvent) {
        switch event {
        case .inputChanged:
            view.inputFieldsWasUpdated()
        case .buttonAction(let parameters, let viewModel):
            actionTapped(action: parameters, viewModel: viewModel)
        default:
            guard let action = event.actionParameters() else { return }
            actionTapped(action: action)
        }
    }
    
    // MARK: - API Methods
    private func fetchScreen() {
        view.setInnerTridentLoading(.loading)
        apiClient
            .getOnboarding(documentType: documentType)
            .observe { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let response):
                    self.didRetry = false
                    self.view.setInnerTridentLoading(.ready)
                    self.processResponse(response)
                case .failed(let error):
                    self.handleError(error: error) { [weak self] in
                        self?.fetchScreen()
                    }
                default:
                    return
                }
            }
            .dispose(in: bag)
    }
    
    // MARK: - Private Methods
    private func actionTapped(action: DSActionParameter, viewModel: DSLoadingButtonViewModel? = nil) {
        self.buttonViewModel = viewModel
        switch action.type {
        case Constants.activateEudiWallet:
            activateEudiWallet()
        case Constants.backAction:
            view.closeModule(animated: true)
        default:
            log(String(describing: action.type))
        }
    }
    
    private func processResponse(_ response: DSConstructorModel) {
        updateContextMenu(model: response, in: &contextMenuProvider)
        view.configure(model: response)
        if let template = response.template {
            handleAlert(alert: template)
        }
    }
    
    private func activateEudiWallet() {
        buttonViewModel?.state.value = .loading
        Task { [weak self] in
            guard let self else { return }
            
            do {
//                if self.documentType == .pid {
//                    try await self.walletController.clearAllDocuments()
//                }
//                try await self.walletController.issueDocument(
//                    docType: docType,
//                    dataFormats: self.documentType.supportedFormats
//                )
                try await self.walletController.issueDocument(
                    issuerId: documentType.issuerId,
                    identifier: documentType.identifier
                )

                await MainActor.run {
                    self.buttonViewModel?.state.value = .enabled
                    DocumentsProcessor.instance.refreshDocumentFromStorage(type: self.documentType.docType.rawValue)
                    NotificationCenter.default.post(name: AppConstants.Notifications.documentsWasReordered, object: nil)
                    self.handleAlert(alert: Constants.successAlert)
                }
            } catch let EudiWalletCredentialIssuanceError.template(alertTemplate) {
                await MainActor.run {
                    self.buttonViewModel?.state.value = .enabled
                    self.handleAlert(alert: alertTemplate)
                }
            } catch {
                await MainActor.run {
                    self.buttonViewModel?.state.value = .enabled
                    self.handleAlert(alert: Constants.errorAlert)
                }
            }
        }
    }
    
    // MARK: - Handlers
    private func handleAlert(alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .ok:
                self.flowCoordinator.restartFlow()
                self.view.closeModule(animated: true)
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

// MARK: - Constants
private extension EudiWalletOnboardingPresenter {
    enum Constants {
        static let activateEudiWallet = "activate_document"
        static let backAction = "back"
        
        static var successAlert: AlertTemplate = .init(
            type: .middleCenterAlignAlert,
            isClosable: false,
            data: AlertTemplateData(
                icon: "🇪🇺",
                title: "Документ сформовано",
                description: "Дія сформувала міжнародний документ, якими ви зможете скористатися за кордоном.",
                mainButton: AlertButtonModel(
                    title: "Зрозуміло",
                    icon: nil,
                    action: .ok),
                alternativeButton: nil)
        )
        
        static var errorAlert: AlertTemplate = .init(
            type: .middleCenterAlignAlert,
            isClosable: false,
            data: AlertTemplateData(
                icon: "😞",
                title: "Неможливо активувати документ",
                description: "Реєстр захворів...",
                mainButton: AlertButtonModel(
                    title: "Зрозуміло",
                    icon: nil,
                    action: .close),
                alternativeButton: nil)
        )
    }
}
