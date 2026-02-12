//
//  EudiQRCodeView.swift
//  Diia
//
//  Created by Nikita Koruts on 29.11.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import UIKit
import Lottie
import DiiaCommonTypes
import DiiaUIComponents

public class EudiQRCodeView: BaseCodeView {
    
    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let label = UILabel().withParameters(
            font: FontBook.usualFont,
            textAlignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let qrCodeView: DSQRCodeMlcView = {
        let view = DSQRCodeMlcView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imagePlaceholder: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = Constants.cornerRadius
        
        addSubviews([titleLabel, qrCodeView])
        qrCodeView.addSubview(imagePlaceholder)
        
        imagePlaceholder.withSize(Constants.placeholderSize)
        NSLayoutConstraint.activate([
            imagePlaceholder.centerXAnchor.constraint(equalTo: qrCodeView.centerXAnchor),
            imagePlaceholder.centerYAnchor.constraint(equalTo: qrCodeView.centerYAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: qrCodeView.topAnchor, constant: -32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            qrCodeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            qrCodeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            qrCodeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            qrCodeView.heightAnchor.constraint(equalTo: qrCodeView.widthAnchor)
        ])
    }
    
    // MARK: - Public Methods
    public func configure(title: String, link: String) {
        titleLabel.text = title
        qrCodeView.configure(for: .init(qrLink: link))
    }
    
    public func setLoadingState(_ state: LoadingState) {
        switch state {
        case .loading:
            imagePlaceholder.isHidden = false
            imagePlaceholder.play()
        case .ready:
            imagePlaceholder.isHidden = true
            imagePlaceholder.stop()
        }
    }
}

// MARK: - Constants
private extension EudiQRCodeView {
    enum Constants {
        static let cornerRadius: CGFloat = 24
        static let placeholderSize = CGSize(width: 60, height: 60)
        static let animationName = "placeholder_black"
    }
}
