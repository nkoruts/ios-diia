//
//  EudiDocumentIssuancePresenter.swift
//

import UIKit
import EudiWalletKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices

final class EudiDocumentIssuancePresenter: ConstructorScreenPresenter {
    
    // MARK: - Properties
    unowned var view: ConstructorScreenViewProtocol
    private let walletKit: EudiWalletKitProtocol
    
    private let offerUri: String
    private var offer: OfferedIssuanceModel?
    
    // MARK: - Init
    init(view: ConstructorScreenViewProtocol, offerUri: String) {
        self.view = view
        self.offerUri = offerUri
        self.walletKit = EudiWalletKitController.instance
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.showProgress()
        Task { [weak self] in
            guard let self else { return }
            let offer = try await self.walletKit.resolveOfferUrlDocTypes(offerUri: offerUri)
            self.offer = offer
            await MainActor.run { self.buildScreen() }
        }
    }
    
    func handleEvent(event: ConstructorItemEvent) {
        switch event {
        case .inputChanged:
            view.inputFieldsWasUpdated()
        default:
            guard let action = event.actionParameters() else { return }
            actionTapped(action: action)
        }
    }
    
    // MARK: - Private Methods -
    private func issueDocument() {
        guard let offer else { return }
        view.showProgress()
        Task { [weak self] in
            guard let self else { return }
            let documents = try await self.walletKit.issueDocumentsByOfferUrl(
                offerUri: offerUri,
                docTypes: offer.docModels,
                txCodeValue: nil
            )
            await MainActor.run {
                if let presentationUrl = documents.first?.authorizePresentationUrl {
                    self.openPresentationModule(with: presentationUrl)
                } else {
                    self.processSuccessIssuance()
                }
            }
        }
    }
    
    private func openPresentationModule(with url: String) {
        let redirectCallback = { [weak self] redirectUrl in
            guard let self else { return }
            self.view.showProgress()
            Task {
                _ = try await self.walletKit.resumePendingIssuance(webUrl: redirectUrl)
                await MainActor.run { self.processSuccessIssuance() }
            }
        }
        let module = EudiWalletRemoteSharingModule(link: url, redirectCallback: redirectCallback)
        view.open(module: module)
    }
    
    private func processSuccessIssuance() {
//        DocumentsProcessor.instance.refreshDocumentFromStorage(type: self.documentType.docType.rawValue)
        NotificationCenter.default.post(name: AppConstants.Notifications.documentsWasReordered, object: nil)
        view.hideProgress()
        handleAlert(alert: Constants.successAlert)
    }
    
    private func buildScreen() {
        guard let offer else { return }
        let body: [AnyCodable] = offer.docModels.reduce(into: [
            .dictionary(["titleLabelMlc": .fromEncodable(
                encodable: DSTitleLabelMlc(
                    label: "Запит на отримання",
                    componentId: nil)
            )]),
            .dictionary(["textLabelMlc": .fromEncodable(
                encodable: DSTextContainerData(
                    componentId: nil,
                    text: "Нам потрібен Ваш дозвіл та автентифікація для отримання наступного документа:",
                    label: nil)
            )])
        ]) { partialResult, docModel in
            let items: [AnyCodable] = [
                .dictionary(["tableSecondaryHeadingMlc": .fromEncodable(
                    encodable: DSTableHeadingItemModel(
                        label: "\(docModel.displayName) 🇪🇺",
                        description: "Основний ідентифікаційний документ, яким ви можете підтвердити свою особу."
                    )
                )])
            ]
            partialResult.append(
                .dictionary(["backgroundWhiteOrg": .fromEncodable(
                    encodable: DSBackgroundWhiteOrgModel(
                        componentId: nil,
                        id: "",
                        items: items
                    )
                )])
            )
        }
        let model = DSConstructorModel(
            topGroup: [
                .dictionary(["topGroupOrg": .fromEncodable(encodable: DSTopGroupOrg(
                    navigationPanelMlc: .init(label: "eWallet", ellipseMenu: nil))
                )])
            ],
            body: body,
            bottomGroup: [
                .dictionary(
                    ["bottomGroupOrg": .fromEncodable(encodable: DSBottomGroupOrg(
                        componentId: nil,
                        checkboxBtnOrg: nil,
                        btnPrimaryDefaultAtm: DSButtonModel(
                            label: "Додати документ",
                            action: .init(type: "issueDocument"),
                            componentId: nil
                        ),
                        btnPlainAtm: DSButtonModel(
                            label: "Ні, дякую",
                            action: .init(type: "dismiss"),
                            componentId: nil
                        ),
                        btnStrokeDefaultAtm: nil,
                        btnLoadIconPlainGroupMlc: nil,
                        btnPrimaryLargeAtm: nil
                    )
                )]
        )
            ]
        )
        view.hideProgress()
        view.configure(model: model)
    }
    
    // MARK: - Handlers
    private func actionTapped(action: DSActionParameter) {
        switch action.type {
        case Constants.issueDocumentAction:
            issueDocument()
        case Constants.dismissAction, Constants.backAction:
            view.closeModule(animated: true)
        default:
            log(String(describing: action.type))
        }
    }

    private func handleAlert(alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { [weak self] _ in
            guard let self = self else { return }
            self.view.closeModule(animated: true)
        }
    }
}

// MARK: - EudiDocumentIssuancePresenter+Constants
private extension EudiDocumentIssuancePresenter {
    enum Constants {
        static let issueDocumentAction = "issueDocument"
        static let dismissAction = "dismiss"
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
    }
}
