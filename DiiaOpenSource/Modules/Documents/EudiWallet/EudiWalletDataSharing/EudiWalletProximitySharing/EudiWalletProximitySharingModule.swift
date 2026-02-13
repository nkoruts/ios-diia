//
//  EudiWalletProximitySharingModule.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class EudiWalletProximitySharingModule: BaseModule {
    private let view: ConstructorViewController
    private let presenter: EudiWalletProximitySharingPresenter

    init(
        request: EudiPresentationRequest,
        sessionManager: EudiWalletProximitySessionManager
    ) {
        view = ConstructorViewController()
        presenter = EudiWalletProximitySharingPresenter(
            request: request,
            sessionManager: sessionManager,
            view: view,
            flowCoordinator: PublicServiceFlowCoordinator(rootView: view)
        )
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
