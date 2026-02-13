//
//  CorCardViewModel.swift
//

import UIKit
import DiiaNetwork
import ReactiveKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaDocumentsCore
import DiiaCommonServices
import DiiaDocumentsCommonTypes

final class CorCardViewModel: DocumentModel {
    
    // MARK: - Properties
    let model: DSDocumentData?
    let docNumber: String
    let nameRaw: String
    var errorViewModel: DocumentErrorViewModel?
    
    // MARK: - DocumentViewModel
    var id: String { model?.id ?? "" }
    var orderIdentifier: String { docNumber }
    let docType: DocumentAttributesProtocol? = DocType.corDocument
    var images = [DSDocumentContentData: UIImage]()
    
    var shortDescription: String {
        return [docNumber, nameRaw].joined(separator: ", ")
    }
    
    lazy var frontView: FrontViewProtocol = {
        let view: DSDocumentWithPhotoView = DSDocumentWithPhotoView()
        let viewModel = DSDocumentWithPhotoViewModel(
            model: model,
            images: images,
            docType: docType,
            errorViewModel: errorViewModel
        )
        view.configure(for: viewModel)
        return view
    }()
    
    // MARK: - Init
    init(data: DSDocumentData) {
        self.model = data
        self.docNumber = data.docNumber
        self.nameRaw = data.docData.fullName ?? ""
        self.errorViewModel = nil
        data.content?.forEach {
            images[$0.code] = UIImage.createWithBase64String($0.image)
        }
    }
    
    // MARK: - Actions
    func backView(for type: VerificationType?, flippingAction: @escaping Callback) -> FlippableEmbeddedView? {
        return nil
    }
    
    func getCardActions(view: BaseView, flipper: FlipperVerifyProtocol) -> [[Action]] {
        return commonActions(view: view)
    }
    
    func getAccessibilityMenuAction(view: BaseView, flipper: FlipperVerifyProtocol, inStack: Bool) -> [[Action]] {
        if inStack {
            return getInstackCardActions(view: view, flipper: flipper)
        } else {
            return getCardActions(view: view, flipper: flipper)
        }
    }
    
    func sharingRequest() -> Signal<ShareLinkModel, NetworkError>? {
        return nil
    }
    
    func getInstackCardActions(view: BaseView, flipper: FlipperVerifyProtocol) -> [[Action]] {
        return []
    }
    
    // MARK: - Private Methods
    private func commonActions(view: BaseView) -> [[Action]] {
        return [[
            Action(
                title: "Повна інформація",
                image: nil,
                callback: { [weak self, weak view] in
                    guard let self = self, let view = view else { return }
                    self.openDocumentDetails(in: view)
                }),
            Action(
                title: "Відкликати документ",
                image: nil,
                callback: { [weak self, weak view] in
                    guard let self = self, let view = view else { return }
                    self.deleteDocument(in: view)
                })
        ]]
    }
    
    private func openDocumentDetails(in view: BaseView) {
        guard let docData = self.model else { return }
        
        let viewModel = DocumentDetailsCommonViewModel(
            model: docData,
            images: images,
            eventHandler: nil
        )
        view.showChild(module: DocumentDetailsCommonModule(with: viewModel))
    }
    
    private func deleteDocument(in view: BaseView, force: Bool = false) {
        guard force else {
            handleTemplate(Constants.confirmDeletionAlert, in: view)
            return
        }
        
        Task {
            let docType = model?.docData.docType ?? EudiWalletDocumentType.cor.rawValue
            try await EudiWalletKitController.instance.deleteDocuments(with: docType)
            await MainActor.run {
                DocumentsProcessor.instance.refreshDocumentFromStorage(type: DocType.corDocument.rawValue)
                NotificationCenter.default.post(name: AppConstants.Notifications.documentsWasReordered, object: nil)
            }
        }
    }
    
    private func handleTemplate(_ template: AlertTemplate, in view: BaseView) {
        TemplateHandler.handle(template, in: view) { [weak self, weak view] action in
            guard let self = self, let view = view else { return }
            switch action {
            case .delete:
                self.deleteDocument(in: view, force: true)
            default:
                break
            }
        }
    }
}

// MARK: - Constants
private extension CorCardViewModel {
    enum Constants {
        static let confirmDeletionAlert: AlertTemplate = AlertTemplate(
            type: .middleCenterBlackButtonAlert,
            isClosable: false,
            data: AlertTemplateData(
                icon: "☝️",
                title: "Видалити документ?",
                description: "Ви зможете активувати його повторно з галереї документів.",
                mainButton: AlertButtonModel(
                    title: "Видалити документ",
                    icon: nil,
                    action: .delete),
                alternativeButton: AlertButtonModel(
                    title: "Скасувати",
                    icon: nil,
                    action: .cancel)
            )
        )
    }
}
