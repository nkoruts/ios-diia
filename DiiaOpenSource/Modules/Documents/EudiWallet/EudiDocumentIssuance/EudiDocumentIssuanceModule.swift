//
//  EudiDocumentIssuanceModule.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class EudiDocumentIssuanceModule: BaseModule {
    private let view: ConstructorViewController
    private let presenter: EudiDocumentIssuancePresenter

    init(offerUri: String) {
        view = ConstructorViewController()
        presenter = EudiDocumentIssuancePresenter(view: view, offerUri: offerUri)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
