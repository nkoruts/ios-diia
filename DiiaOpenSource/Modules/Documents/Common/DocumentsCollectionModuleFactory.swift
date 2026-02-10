import Foundation
import DiiaNetwork
import ReactiveKit
import DiiaDocumentsCommonTypes
import DiiaDocumentsCore

extension DocumentsCoreNetworkContext {
    static func create() -> DocumentsCoreNetworkContext {
        .init(
            session: NetworkConfiguration.default.session,
            host: EnvironmentVars.apiHost,
            headers: nil
        )
    }
}

class MockDocumentsLoader: DocumentsLoaderProtocol {
    func updateIfNeeded() { }
    func setNeedUpdates() { }
    func removeListener(listener: DocumentsLoadingListenerProtocol) { }
    func addListener(listener: DocumentsLoadingListenerProtocol) { }
}

// TODO: - CLEAR CONTEXT
struct DocumentsCollectionModuleFactory {
    static func create(holder: DocumentCollectionHolderProtocol) -> DocumentsCollectionModule {
        
        let reorderingConfig = DocumentsReorderingConfiguration(createReorderingModule: { DocumentsReorderingModule() },
                                                                documentsReorderingService: DocumentReorderingService.shared)
        return  .init(context: .init(network: .create(),
                                     documentsLoader: MockDocumentsLoader(),
                                     docProvider: DocumentsProcessor(),
                                     documentsStackRouterCreate: {
                                        DocumentsStackRouter(docType: $0, docProvider: DocumentsProcessor())
                                     },
                                     actionFabricAllowedCodes: [DocType.driverLicense.docCode],
                                     documentsReorderingConfiguration: reorderingConfig,
                                     pushNotificationsSharingSubject: PassthroughSubject<Void, Never>(),
                                     addDocumentsActionProvider: AddDocumentsActionProvider(),
                                     imageNameProvider: DSImageNameResolver.instance,
                                     screenBrightnessService: ScreenBrightnessHelper.shared),
                      holder: holder
        )
    }
}
