//
//  EudiWalletKitController.swift
//

import Foundation
import OpenID4VCI
import EudiWalletKit
import WalletStorage
import MdocDataModel18013

public protocol EudiWalletKitProtocol {
    var isStorageEmpty: Bool { get }
    var isWalletActivated: Bool { get }
    func resolveOfferUrlDocTypes(offerUri: String) async throws -> OfferedIssuanceModel
    func issueDocument(issuerId: String, identifier: String) async throws -> WalletStorage.Document
    func issueDocumentsByOfferUrl(offerUri: String, docTypes: [OfferedDocModel], txCodeValue: String?) async throws -> [WalletStorage.Document]
    func resumePendingIssuance(webUrl: String) async throws -> WalletStorage.Document
    
    func loadDocuments() async throws
    func fetchDocuments(with type: String) -> [DocClaimsDecodable]
    func fetchDocument(with id: String) -> DocClaimsDecodable?
    func clearAllDocuments() async throws
    func deleteDocuments(with docType: String) async throws
    func deleteDocument(with id: String) async throws
}

final class EudiWalletKitController: EudiWalletKitProtocol {
    
    static let instance = EudiWalletKitController()
    
    private let configLogic: EudiWalletKitConfig
    private let wallet: EudiWallet
    
    public var isStorageEmpty: Bool {
        return wallet.storage.docModels.isEmpty
    }
    
    /// Return 'false' if no documents have been uploaded from storage.
    public var isWalletActivated: Bool {
        return !fetchDocuments(with: EuPidModel.euPidDocType).isEmpty
    }
    
    private init(configLogic: EudiWalletKitConfig = EudiWalletKitConfig()) {
        self.configLogic = configLogic
        
        guard let walletKit = try? EudiWallet(
          serviceName: configLogic.serviceName,
          trustedReaderCertificates: configLogic.trustedCerts,
          userAuthenticationRequired: configLogic.userAuthenticationRequired,
          openID4VpConfig: configLogic.vpConfig,
          openID4VciConfigurations: configLogic.vciConfig
        ) else {
          fatalError("Unable to Initialize WalletKit")
        }
        
        wallet = walletKit
    }
    
    public func resolveOfferUrlDocTypes(offerUri: String) async throws -> OfferedIssuanceModel {
        return try await wallet.resolveOfferUrlDocTypes(offerUri: offerUri)
    }
    
    public func issueDocument(issuerId: String, identifier: String) async throws -> WalletStorage.Document {
//      let rule = configLogic.documentIssuanceConfig.rule(for: docTypeIdentifier)
      return try await wallet.issueDocument(
        issuerName: issuerId,
        docTypeIdentifier: .identifier(identifier),
        credentialOptions: nil
      )
    }
    
    public func issueDocumentsByOfferUrl(offerUri: String, docTypes: [OfferedDocModel], txCodeValue: String?) async throws -> [WalletStorage.Document] {
        //        let docTypes = docTypes.map { docType in
        //            let rule = configLogic.documentIssuanceConfig.rule(for: docType.documentTypeIdentifier)
        //            let credentialOptions: CredentialOptions = .init(credentialPolicy: rule.policy, batchSize: rule.numberOfCredentials)
        //            return docType.copy(credentialOptions: credentialOptions)
        //        }
        return try await wallet.issueDocumentsByOfferUrl(offerUri: offerUri, docTypes: docTypes, txCodeValue: txCodeValue)
    }
    
    public func resumePendingIssuance(webUrl: String) async throws -> WalletStorage.Document {
        guard let webUrl = webUrl.toCompatibleUrl(),
              let pendingDocument = wallet.storage.pendingDocuments.last,
              let metadata = DocMetadata(from: pendingDocument.metadata)
        else {
            throw EudiWalletError.missingMetadata
        }
        
//        let rule = configLogic.documentIssuanceConfig.rule(for: pendingDoc.documentTypeIdentifier)
        let credentialIssuerIdentifier = "https://\(metadata.credentialIssuerIdentifier)"
        return try await wallet.resumePendingIssuance(
            issuerName: credentialIssuerIdentifier,
            pendingDoc: pendingDocument,
            webUrl: webUrl,
            credentialOptions: .init(credentialPolicy: .rotateUse, batchSize: 100) // Add credentialOptions using rule
        )
    }
    
    public func loadDocuments() async throws {
        try await wallet.loadAllDocuments()
    }
    
    public func fetchDocument(with id: String) -> DocClaimsDecodable? {
        wallet.storage.getDocumentModel(id: id)
    }
    
    public func fetchDocuments(with type: String) -> [DocClaimsDecodable] {
        return wallet.storage.docModels
            .filter({ $0.docType == type })
    }
    
    public func clearAllDocuments() async throws {
        try await wallet.deleteAllDocuments()
    }
    
    public func deleteDocuments(with docType: String) async throws {
//        return try await wallet.storage.deleteDocuments(docType: docType)
    }
    
    public func deleteDocument(with id: String) async throws {
        return try await wallet.deleteDocument(id: id, status: .issued)
    }
    
    // MARK: - Presentation
    public func startProximityPresentation() async -> PresentationSession {
        return await wallet.beginPresentation(flow: .ble)
    }
    
    public func startRemotePresentation(urlString: String) async -> PresentationSession {
        let data = urlString.data(using: .utf8) ?? Data()
        return await wallet.beginPresentation(flow: .openid4vp(qrCode: data))
    }
}

public extension String {
    func toCompatibleUrl() -> URL? {
        guard let decoded = self.removingPercentEncoding else { return nil }
        return if let url = URL(string: decoded) {
            url
        } else if let encodedString = decoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedString) {
            url
        } else {
            nil
        }
    }
}
