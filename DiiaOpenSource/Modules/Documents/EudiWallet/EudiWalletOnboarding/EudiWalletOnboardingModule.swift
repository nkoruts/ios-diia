//
//  EWalletOnboardingModule.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class EudiWalletOnboardingModule: BaseModule {
    private let view: ConstructorViewController
    private let presenter: EudiWalletOnboardingPresenter
    
    init(
        documentType: EudiWalletDocumentType,
        flowCoordinator: FlowCoordinatorProtocol? = nil,
        contextMenuProvider: ContextMenuProviderProtocol = BaseContextMenuProvider()
    ) {
        view = ConstructorViewController()
        let flowCoordinator = flowCoordinator ?? PublicServiceFlowCoordinator(
            rootView: view,
            restartCallback: {
                AppRouter.instance.popToTab(with: .documents(type: documentType.docType))
            }
        )
        presenter = EudiWalletOnboardingPresenter(
            documentType: documentType,
            view: view,
            flowCoordinator: flowCoordinator,
            contextMenuProvider: contextMenuProvider
        )
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
