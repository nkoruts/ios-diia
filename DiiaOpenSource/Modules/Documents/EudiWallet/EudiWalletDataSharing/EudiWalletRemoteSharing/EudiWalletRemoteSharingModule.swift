//
//  EudiWalletRemoteSharingModule.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class EudiWalletRemoteSharingModule: BaseModule {
    private let view: ConstructorViewController
    private let presenter: EudiWalletRemoteSharingPresenter

    init(link: String, redirectCallback: ((String) -> Void)? = nil) {
        view = ConstructorViewController()
        presenter = EudiWalletRemoteSharingPresenter(
            view: view,
            link: link,
            redirectCallback: redirectCallback
        )
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
