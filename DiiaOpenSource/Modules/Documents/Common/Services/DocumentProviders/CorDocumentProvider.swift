//
//  CorDocumentProvider.swift
//

import Foundation
import DiiaMVPModule
import DiiaCommonTypes
import MdocDataModel18013
import DiiaDocumentsCommonTypes

class CorDocumentProvider: DocumentModelProvider {
    private let walletController: EudiWalletKitProtocol
    private var documentModel: DSFullDocumentModel?
    private var documentId: String?
    
    let modelKey = "eu.europa.ec.eudi.cor.1"
    let docCode = "COR"
    
    init(walletController: EudiWalletKitProtocol = EudiWalletKitController.instance) {
        self.walletController = walletController
    }
    
    func saveDocumentsToStorage(documentsResponse: AnyCodable) { }
    
    func getStoredDocuments(actionView: BaseView?) -> [DocumentModel] {
        loadDocumentFromStorage()
        return documentModel?.data.map { CorCardViewModel(data: $0) } ?? []
    }
    
    func refreshFromStorage() {
        loadDocumentFromStorage()
    }
    
    func cleanStorage() {
        documentId = nil
        documentModel = nil
    }
        
    func needRemoteUpdates() -> Bool {
        return false
    }
    
    // MARK: - Private Methods
    private func loadDocumentFromStorage() {
        guard !walletController.isStorageEmpty, let docModel = walletController.fetchDocuments(with: modelKey).first else {
            documentModel = nil
            return
        }
        guard documentId != docModel.id else { return }
        
        documentId = docModel.id
        let eudiDocument = EudiCorDocumentModel(docModel)
        documentModel = eudiDocument.fullDocumentModel()
    }
}
