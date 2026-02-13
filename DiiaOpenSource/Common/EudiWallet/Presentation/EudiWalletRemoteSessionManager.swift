//
//  EudiWalletRemoteSessionManager.swift
//

import Combine
import Foundation
import EudiWalletKit
import MdocDataTransfer18013

protocol EudiWalletRemoteSessionDelegate: AnyObject {
    func didFinishPresentation(with redirectUrl: String?)
    func didReceiveRequest(_ request: EudiPresentationRequest)
    func didReceiveError()
}

final class EudiWalletRemoteSessionManager {
    private let walletKitController = EudiWalletKitController.instance
    private var session: PresentationSession?
    private var cancellables = Set<AnyCancellable>()
    
    public weak var delegate: EudiWalletRemoteSessionDelegate?
    
    // MARK: - Public Methods
    public func startRemotePresentation(urlString: String) {
        Task { [weak self] in
            guard let self else { return }
            self.session = await self.walletKitController.startRemotePresentation(urlString: urlString)
            self.observeRemotePresentation()
        }
    }
    
    public func sendResponse(disclosedItems: RequestItems) {
        Task { [weak self, weak session] in
            guard let self = self, let session = session else { return }
            await session.sendResponse(
                userAccepted: true,
                itemsToSend: disclosedItems,
                onCancel: nil
            ) { redirectUrl in
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFinishPresentation(with: redirectUrl?.absoluteString)
                }
            }
        }
    }

    // MARK: - Private Methods
    private func observeRemotePresentation() {
        session?.$status.sink { [weak self] status in
            self?.handleStatusChange(status)
        }.store(in: &cancellables)
    }
    
    private func handleStatusChange(_ status: TransferStatus) {
        switch status {
        case .initializing:
            handleInitializing()
        case .requestReceived:
            handleRequestReceived()
        case .disconnected, .error:
            delegate?.didReceiveError()
        default:
            log("Unhandled status: \(status)")
        }
    }

    private func handleInitializing() {
        Task { [weak session] in
            _ = await session?.receiveRequest()
        }
    }
    
    private func handleRequestReceived() {
        guard let session, !session.disclosedDocuments.isEmpty else {
            log("Failed to Find known documents to send")
            return
        }
        let request = EudiPresentationRequest(
            items: session.disclosedDocuments,
            relyingParty: session.readerCertIssuer ?? "Verifier",
            dataRequestInfo: session.readerCertValidationMessage ?? "Why we need your data?",
            isTrusted: session.readerCertIssuerValid == true
        )
        delegate?.didReceiveRequest(request)
    }
}
