//
//  EudiWalletProximitySessionManager.swift
//

import Combine
import Foundation
import EudiWalletKit
import MdocDataTransfer18013

public protocol EudiWalletProximitySessionDelegate: AnyObject {
    func didGenerateQRCode(_ payload: String)
    func didReceiveRequest(_ request: EudiPresentationRequest)
    func didFinishPresentation()
}

extension EudiWalletProximitySessionDelegate {
    func didGenerateQRCode(_ payload: String) {}
    func didReceiveRequest(_ request: EudiPresentationRequest) {}
}

public final class EudiWalletProximitySessionManager {
    private let walletKitController = EudiWalletKitController.instance
    private var session: PresentationSession?
    private var cancellables = Set<AnyCancellable>()
    
    public weak var delegate: EudiWalletProximitySessionDelegate?
    
    // MARK: - Public Methods
    public func startProximityPresentation() {
        Task { [weak self] in
            guard let self else { return }
            self.session = await self.walletKitController.startProximityPresentation()
            self.observePresentation()
        }
    }
    
    public func sendResponse(disclosedItems: RequestItems) {
        Task { [weak session] in
            guard let session else { return }
            await session.sendResponse(userAccepted: true, itemsToSend: disclosedItems)
        }
    }
    
    // MARK: - Private Methods
    private func observePresentation() {
        session?.$status.sink { [weak self] status in
            self?.handleStatusChange(status)
        }.store(in: &cancellables)
    }
    
    private func handleStatusChange(_ status: TransferStatus) {
        switch status {
        case .initializing:
            handleInitializing()
        case .qrEngagementReady:
            startQrEngagement()
        case .requestReceived:
            handleRequestReceived()
        case .responseSent:
            handleResponseSent()
        default:
            log("Unhandled status: \(status)")
        }
    }
    
    private func startQrEngagement() {
        guard let imageData = session?.deviceEngagement, !imageData.isEmpty else { return }
        delegate?.didGenerateQRCode(imageData)
    }
    
    private func handleInitializing() {
        Task { [weak session] in
            guard let session else { return }
            do {
                try await session.startQrEngagement()
                _ = await session.receiveRequest()
            } catch {
                log(error) // TODO: - Handle startQrEngagement error
            }
        }
    }
    
    private func handleRequestReceived() {
        guard let session, !session.disclosedDocuments.isEmpty else { return }
        let request = EudiPresentationRequest(
            items: session.disclosedDocuments,
            relyingParty: session.readerCertIssuer ?? "Verifier",
            dataRequestInfo: session.readerCertValidationMessage ?? "Why we need your data?",
            isTrusted: session.readerCertIssuerValid == true
        )
        delegate?.didReceiveRequest(request)
    }
    
    private func handleResponseSent() {
        delegate?.didFinishPresentation()
    }
}
