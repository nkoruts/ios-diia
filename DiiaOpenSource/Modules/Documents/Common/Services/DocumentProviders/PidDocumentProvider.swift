//
//  PidDocumentProvider.swift
//

import Foundation
import DiiaMVPModule
import DiiaCommonTypes
import MdocDataModel18013
import DiiaDocumentsCommonTypes

class PidDocumentProvider: DocumentModelProvider {
    private let walletController: EudiWalletKitProtocol
    private var documentModel: DSFullDocumentModel?
    private var documentId: String?
    
    let modelKey = "eu.europa.ec.eudi.pid.1"
    let docCode = "PID"
    
    init(walletController: EudiWalletKitProtocol = EudiWalletKitController.instance) {
        self.walletController = walletController
        Task { [weak self] in
            try await self?.walletController.loadDocuments()
        }
    }
    
    func saveDocumentsToStorage(documentsResponse: AnyCodable) { }
    
    func getStoredDocuments(actionView: BaseView?) -> [DocumentModel] {
        loadDocumentFromStorage()
        return documentModel?.data.map { PidCardViewModel(data: $0) } ?? []
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
        let eudiDocument = EudiPidDocumentModel(docModel)
        documentModel = eudiDocument.fullDocumentModel()
    }
}
