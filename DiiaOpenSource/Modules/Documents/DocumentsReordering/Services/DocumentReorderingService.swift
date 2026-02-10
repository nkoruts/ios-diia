import Foundation
import ReactiveKit
import DiiaCommonTypes
import DiiaCommonServices
import DiiaDocumentsCommonTypes
import DiiaDocumentsCore

class DocumentReorderingService: DocumentReorderingServiceProtocol {
    // TODO: - REMOVE
    func synchronizeIfNeeded() {
        
    }
    

    static let shared = DocumentReorderingService(store: StoreHelper.instance)
    
    private let store: StoreHelperProtocol
    private let bag = DisposeBag()
    
    private init(store: StoreHelperProtocol) {
        self.store = store
    }
    
    // MARK: - DocumentReorderingServiceProtocol
    func docTypesOrder() -> [DocTypeCode] {
        let order: [DocType] = store.getValue(forKey: .docsOrder) ?? DocType.allCardTypes
        return order.map(\.rawValue)
    }
    
    func setOrder(order: [DocTypeCode], synchronize: Bool) {
        let newOrder = order.compactMap({ DocType(rawValue: $0) })
        let storedOrder = docTypesOrder().compactMap({ DocType(rawValue: $0) })
        guard newOrder != storedOrder else { return }
        store.save(newOrder, type: [DocType].self, forKey: .docsOrder)
        NotificationCenter.default.post(name: AppConstants.Notifications.documentsWasReordered, object: nil)
    }
    
    func order(for type: DocTypeCode) -> [String] {
        guard let docType = DocType(rawValue: type),
              let docsOrder: [DocType: [String]] = store.getValue(forKey: .docsStackOrder),
              let order = docsOrder[docType]
        else { return [] }
        return order
    }
    
    func setOrder(order: [String], for type: DocTypeCode) {
        guard let docType = DocType(rawValue: type) else { return }
        var docsOrder: [DocType: [String]] = store.getValue(forKey: .docsStackOrder) ?? [:]
        docsOrder[docType] = order
        store.save(docsOrder, type: [DocType: [String]].self, forKey: .docsStackOrder)
        NotificationCenter.default.post(name: AppConstants.Notifications.documentsWasReordered, object: nil)
    }
    
    func cleanSynchronized(for type: DocTypeCode) {
        guard let docType = DocType(rawValue: type) else { return }
        guard var order: [DocType: [String]] = store.getValue(forKey: .docsStackOrder) else { return }
        order[docType] = nil
        store.save(order, type: [DocType: [String]].self, forKey: .docsStackOrder)
    }
    
    func updateOrdersIfNeeded() {
        guard let order: [DocType] = store.getValue(forKey: .docsOrder) else { return }
        setOrder(order: order.map(\.rawValue), synchronize: false)
    }
}
