import Foundation
import DiiaMVPModule
import DiiaCommonTypes
import DiiaDocumentsCommonTypes
import DiiaDocuments
import DiiaDocumentsCore

class DocumentsProcessor {
    static let instance = DocumentsProcessor(documentProviders: [
        PidDocumentProvider(),
        MdlDocumentProvider(),
        CorDocumentProvider()
    ])

    public let documentsProviders: [String: DocumentModelProvider]
    
    init(documentProviders: [DocumentModelProvider]) {
        self.documentsProviders = Dictionary(documentProviders.map { ($0.docCode, $0) }) { _, last in last }
        documentProviders.forEach { $0.migrateIfNeeded() }
    }
    
    func documents(with order: [DocTypeCode], actionView: BaseView?) -> [MultiDataType<DocumentModel>] {
        var allDocuments: [MultiDataType<DocumentModel>] = []
        for docCode in order {
            if let docProvider = documentsProviders[docCode] {
                let docs = reorderIfNeeded(
                    documents: docProvider.getStoredDocuments(actionView: actionView),
                    orderIds: DocumentReorderingService.shared.order(for: docCode))
                if let cards = makeMultiple(cards: docs) {
                    allDocuments.append(cards)
                }
            }
        }
        
        return allDocuments
    }
    
    func refreshDocumentFromStorage(type: DocTypeCode) {
        documentsProviders[type]?.refreshFromStorage()
    }
    
    private func makeMultiple(cards: [DocumentModel]) -> MultiDataType<DocumentModel>? {
        if cards.isEmpty {
            return nil
        } else if cards.count == 1 {
            return .single(cards[0])
        } else {
            return .multiple(cards)
        }
    }
    
    private func reorderIfNeeded(documents: [DocumentModel], orderIds: [String]) -> [DocumentModel] {
        if !orderIds.isEmpty {
            var newDocs = documents
            for id in orderIds.reversed() {
                if let index = newDocs.firstIndex(where: { $0.orderIdentifier == id }) {
                    let document = newDocs.remove(at: index)
                    newDocs.insert(document, at: 0)
                }
            }
            return newDocs
        }
        return documents
    }
}

extension DocumentsProcessor: DocumentsProvider { }
