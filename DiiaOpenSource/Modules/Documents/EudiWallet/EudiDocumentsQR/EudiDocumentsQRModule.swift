//
//  EudiDocumentsQRModule.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

public final class EudiDocumentsQRModule: BaseModule {
    private let view: EudiDocumentsQRViewController
    private let presenter: EudiDocumentsQRPresenter

    init(onClose: Callback? = nil) {
        view = EudiDocumentsQRViewController()
        presenter = EudiDocumentsQRPresenter(view: view, onClose: onClose)
        view.presenter = presenter
    }

    public func viewController() -> UIViewController {
        let childContainer = ChildContainerViewController()
        childContainer.childSubview = view
        childContainer.presentationStyle = .presentation
        childContainer.isClosingAlowed = false
        return childContainer
    }
}
