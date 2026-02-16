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

struct DocumentsCollectionModuleFactory {
    static func create(holder: DocumentCollectionHolderProtocol) -> DocumentsCollectionModule {
        
        let reorderingConfig = DocumentsReorderingConfiguration(
            createReorderingModule: { DocumentsReorderingModule() },
            documentsReorderingService: DocumentReorderingService.shared
        )
    
        return  .init(context: .init(
            docProvider: DocumentsProcessor.instance,
            documentsStackRouterCreate: {
                DocumentsStackRouter(docType: $0, docProvider: DocumentsProcessor.instance)
            },
            documentsReorderingConfiguration: reorderingConfig,
            addDocumentsService: AddDocumentsService(),
            activationModule: { EudiWalletOnboardingModule(documentType: .pid) },
            imageNameProvider: DSImageNameResolver.instance,
            screenBrightnessService: ScreenBrightnessHelper.shared)
        )
    }
}
