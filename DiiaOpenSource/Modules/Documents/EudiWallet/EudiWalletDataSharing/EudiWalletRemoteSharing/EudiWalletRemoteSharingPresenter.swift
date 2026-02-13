//
//  EudiWalletRemoteSharingPresenter.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices
import MdocDataModel18013
import MdocDataTransfer18013

final class EudiWalletRemoteSharingPresenter: ConstructorScreenPresenter {
    
    // MARK: - Properties
    unowned var view: ConstructorScreenViewProtocol
    
    private let flowCoordinator: FlowCoordinatorProtocol
    private let remoteSessionManager = EudiWalletRemoteSessionManager()
    private let sharingDataHandler = EudiWalletSharingDataHandler()
    
    private let link: String
    private let redirectCallback: ((String) -> Void)?
    private var redirectUrl: String?
    private var isWarningMessageShowed: Bool = false
    private var buttonViewModel: DSLoadingButtonViewModel?
    
    // MARK: - Init
    init(
        view: ConstructorScreenViewProtocol,
        link: String,
        redirectCallback: ((String) -> Void)?
    ) {
        self.view = view
        self.link = link
        self.redirectCallback = redirectCallback
        let flowCoordinator = PublicServiceFlowCoordinator(rootView: nil)
        self.flowCoordinator = flowCoordinator
        flowCoordinator.restartCallback = { [weak self] in
            self?.configureView()
        }
        self.remoteSessionManager.delegate = self
    }
    
    // MARK: - Public Methods
    func configureView() {
        fetchStoredDocuments()
    }
    
    func handleEvent(event: ConstructorItemEvent) {
        switch event {
        case .inputChanged(let inputModel):
            if !isWarningMessageShowed, case let .bool(isSelected) = inputModel.inputData, !isSelected {
                let components = inputModel.inputCode.components(separatedBy: "/")
                guard let elementId = components.first,
                      let docId = components.last,
                      let selectedItem = sharingDataHandler.getDocItem(by: docId, elementIdentifier: elementId),
                      !selectedItem.isOptional
                else { return }
                        
                isWarningMessageShowed.toggle()
                showWarningMessage("Поширення вибіркових даних може вплинути на доступність сервісу.")
            }
            guard !view.getInputData().isEmpty else {
                buttonViewModel?.state.value = .disabled
                return
            }
            view.inputFieldsWasUpdated()
        case .onComponentConfigured(let type):
            if case let .loadingButton(viewModel) = type {
                self.buttonViewModel = viewModel
            }
        default:
            guard let action = event.actionParameters() else { return }
            actionTapped(action: action)
        }
    }
    
    // MARK: - Private Methods
    private func fetchStoredDocuments() {
        view.setInnerTridentLoading(.loading)
        
        guard EudiWalletKitController.instance.isWalletActivated else {
            handleAlert(alert: Constants.noDocumentsAlert)
            view.setInnerTridentLoading(.ready)
            return
        }
        remoteSessionManager.startRemotePresentation(urlString: link)
    }
    
    private func actionTapped(action: DSActionParameter) {
        switch action.type {
        case Constants.sendSelectiveDisclosureAction:
            let inputData = view.getInputData()
            buttonViewModel?.state.value = .loading
            let selectedItems = sharingDataHandler.transformAnyCodableToRequest(input: inputData)
            if selectedItems.isEmpty {
                handleAlert(alert: Constants.errorAlert)
                return
            }
            remoteSessionManager.sendResponse(disclosedItems: selectedItems)
        case Constants.backAction:
            view.closeModule(animated: true)
        default:
            log(String(describing: action.type))
        }
    }
    
    private func processRequest(_ request: EudiPresentationRequest) {
        let constructorModel = sharingDataHandler.prepareConstructorModel(for: request)
        view.configure(model: constructorModel)
        view.setInnerTridentLoading(.ready)
    }
    
    private func showWarningMessage(_ message: String) {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        view.showError(error: message)
    }
    
    // MARK: - Navigation
    private func openCreateWalletModule() {
        view.open(module: EudiWalletOnboardingModule(
            documentType: .pid,
            flowCoordinator: flowCoordinator
        ))
    }
    
    // MARK: - Handlers
    private func handleAlert(alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .resume:
                self.openCreateWalletModule()
            case .ok:
                if let redirectCallback, let redirectUrl {
                    redirectCallback(redirectUrl)
                } else if let redirectUrl {
                    CommunicationHelper.url(urlString: redirectUrl)
                }
                fallthrough
            default:
                self.view.closeModule(animated: true)
            }
        }
    }
}

// MARK: - EudiWalletRemoteSession Delegate
extension EudiWalletRemoteSharingPresenter: EudiWalletRemoteSessionDelegate {
    func didReceiveRequest(_ request: EudiPresentationRequest) {
        processRequest(request)
    }
    
    func didFinishPresentation(with redirectUrl: String?) {
        self.redirectUrl = redirectUrl
        buttonViewModel?.state.value = .enabled
        handleAlert(alert: Constants.successAlert)
    }
    
    func didReceiveError() {
        handleAlert(alert: Constants.errorAlert)
    }
}

// MARK: - Constants
private extension EudiWalletRemoteSharingPresenter {
    enum Constants {
        static let sendSelectiveDisclosureAction = "send_selective_disclosure"
        static let backAction = "back"
        
        static var successAlert: AlertTemplate = .init(
            type: .middleCenterAlignAlert,
            isClosable: false,
            data: AlertTemplateData(
                icon: "👍",
                title: "Дані успішно надіслані",
                description: nil,
                mainButton: AlertButtonModel(
                    title: "Зрозуміло",
                    icon: nil,
                    action: .ok
                ),
                alternativeButton: nil
            )
        )
        
        static var errorAlert: AlertTemplate = .init(
            type: .middleCenterAlignAlert,
            isClosable: false,
            data: AlertTemplateData(
                icon: "☝️",
                title: "Не вдалось опрацювати запит на поширення даних",
                description: "Будь ласка, спробуйте повторити пізніше.",
                mainButton: AlertButtonModel(
                    title: "Зрозуміло",
                    icon: nil,
                    action: .cancel
                ),
                alternativeButton: nil
            )
        )
        
        static var noDocumentsAlert: AlertTemplate = .init(
            type: .middleCenterBlackButtonAlert,
            isClosable: false,
            data: AlertTemplateData(
                icon: "☝️",
                title: "Немає потрібного документу",
                description: "Не вдалось опрацювати запит на поширення даних. Активуйте необхідний документ.",
                mainButton: AlertButtonModel(
                    title: "Продовжити",
                    icon: nil,
                    action: .resume
                ),
                alternativeButton: AlertButtonModel(
                    title: "Скасувати",
                    icon: nil,
                    action: .cancel
                )
            )
        )
    }
}
