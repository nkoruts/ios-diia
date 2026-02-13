//
//  EudiDocumentsQRViewController.swift
//

import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol EudiDocumentsQRView: BaseView {
    func configureQR(with link: String)
}

final class EudiDocumentsQRViewController: UIViewController, ChildSubcontroller {
    
    // MARK: - Subviews
    public lazy var qrCodeView: EudiQRCodeView = {
        let qrCodeView = EudiQRCodeView()
        qrCodeView.translatesAutoresizingMaskIntoConstraints = false
        return qrCodeView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.setBackgroundColor(.white, for: .normal)
        button.setImage(R.image.clear.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = Constants.closeButtonCornerRadius
        button.layer.masksToBounds = true
        button.imageEdgeInsets = Constants.closeButtonInsets
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.25)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cardTopPadding: CGFloat = {
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
        let cardContainerBottomPadding: CGFloat = safeAreaInsets.bottom + Constants.tabbarHeight + Constants.cardContainerBottomPadding
        let cardContainerHeight = view.frame.height - safeAreaInsets.top - cardContainerBottomPadding // Documents collection height
        return (cardContainerHeight - DocumentsLayoutProvider.cardHeight) / 2
    }()
    
    // MARK: - Properties
    var container: ContainerProtocol?
    var presenter: EudiDocumentsQRAction!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.configureView()
    }
    
    private func setupSubviews() {
        qrCodeView.setLoadingState(.loading)
        
        view.addSubviews([backgroundView, qrCodeView, closeButton])
        
        backgroundView.fillSuperview()
        closeButton.withSize(Constants.closeButtonSize)
        
        NSLayoutConstraint.activate([
            qrCodeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: cardTopPadding),
            qrCodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            qrCodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            qrCodeView.heightAnchor.constraint(equalToConstant: DocumentsLayoutProvider.cardHeight),
            
            closeButton.topAnchor.constraint(equalTo: qrCodeView.bottomAnchor, constant: 32),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        qrCodeView.setLoadingState(.ready)
        container?.close()
        presenter.handleCloseAction()
    }
}

// MARK: - View Logic
extension EudiDocumentsQRViewController: EudiDocumentsQRView {
    func configureQR(with link: String) {
        qrCodeView.setLoadingState(.ready)
        qrCodeView.configure(title: Constants.qrTitleText, link: link)
    }
}

// MARK: - Constants
extension EudiDocumentsQRViewController {
    private enum Constants {
        static let qrTitleText = "Піднесіть QR-код до зчитувача"
        
        static let backgroundColor: UIColor = .black.withAlphaComponent(0.5)
        static let blurIntensity: CGFloat = 0.1
        
        static let closeButtonSize: CGSize = .init(width: 44, height: 44)
        static let closeButtonInsets: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        static let closeButtonCornerRadius: CGFloat = 22
        
        static let tabbarHeight: CGFloat = 70
        static let cardContainerBottomPadding: CGFloat = 16
    }
}
