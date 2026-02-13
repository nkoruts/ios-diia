//
//  EudiWalletProximitySharingPresenter.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices
import MdocDataModel18013
import MdocDataTransfer18013

final class EudiWalletProximitySharingPresenter: ConstructorScreenPresenter {
    
    // MARK: - Properties
    unowned var view: ConstructorScreenViewProtocol
    
    private let flowCoordinator: FlowCoordinatorProtocol
    private let proximitySessionManager: EudiWalletProximitySessionManager
    private let sharingDataHandler = EudiWalletSharingDataHandler()
    
    private let request: EudiPresentationRequest
    private var isWarningMessageShowed: Bool = false
    private var buttonViewModel: DSLoadingButtonViewModel?
    
    // MARK: - Init
    init(
        request: EudiPresentationRequest,
        sessionManager: EudiWalletProximitySessionManager,
        view: ConstructorScreenViewProtocol,
        flowCoordinator: FlowCoordinatorProtocol
    ) {
        self.request = request
        self.proximitySessionManager = sessionManager
        self.view = view
        self.flowCoordinator = flowCoordinator
        self.proximitySessionManager.delegate = self
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setInnerTridentLoading(.loading)
        
        guard !request.items.isEmpty else {
            handleAlert(alert: Constants.noDocumentsAlert)
            view.setInnerTridentLoading(.ready)
            return
        }
        processRequest()
        
        view.setInnerTridentLoading(.ready)
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
    private func actionTapped(action: DSActionParameter) {
        switch action.type {
        case Constants.sendSelectiveDisclosureAction:
            buttonViewModel?.state.value = .loading
            let inputData = view.getInputData()
            let selectedItems = sharingDataHandler.transformAnyCodableToRequest(input: inputData)
            if selectedItems.isEmpty {
                handleAlert(alert: Constants.errorAlert)
                return
            }
            proximitySessionManager.sendResponse(disclosedItems: selectedItems)
        case Constants.backAction:
            view.closeModule(animated: true)
        default:
            log(String(describing: action.type))
        }
    }
    
    private func processRequest() {
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
            default:
                self.view.closeModule(animated: true)
            }
        }
    }
}

// MARK: - EudiWalletProximitySessionDelegate
extension EudiWalletProximitySharingPresenter: EudiWalletProximitySessionDelegate {
    func didFinishPresentation() {
        buttonViewModel?.state.value = .enabled
        handleAlert(alert: Constants.successAlert)
    }
}

// MARK: - Constants
private extension EudiWalletProximitySharingPresenter {
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
