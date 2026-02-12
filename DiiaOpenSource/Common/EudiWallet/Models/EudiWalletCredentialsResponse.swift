//
//  EudiWalletCredentialsResponse.swift
//  Diia
//
//  Created by Nikita Koruts on 06.01.2025.
//  Copyright © 2025 Diia. All rights reserved.
//

import Foundation
import OpenID4VCI
import DiiaCommonTypes
import SwiftyJSON

public struct EudiWalletCredentialIssuanceResponse: Codable {
    let documentData: [EudiWalletCredentialDocumentData]?
    let template: AlertTemplate?
}

public struct EudiWalletCredentialDocumentData: Codable {
    public let credential: JSON?
    public let credentials: [JSON]?
    public let transactionId: String?
    public let notificationId: String?
    public let interval: TimeInterval?
    
    func toDomain() throws -> CredentialIssuanceResponse {
        if let transactionId, let interval {
            return .init(credentialResponses: [
                .deferred(transactionId: try .init(value: transactionId), interval: interval)
            ])
        }
        if let credential, let string = credential.string {
            return .init(credentialResponses: [
                .issued(format: nil, credential: .string(string), notificationId: nil, additionalInfo: nil)
            ])
        }
        guard let credentials, !credentials.isEmpty else {
            throw ValidationError.error(reason: "CredentialIssuanceResponse unparseable")
        }
        return .init(credentialResponses: [
            .issued(format: nil, credential: .json(JSON(credentials)), notificationId: notificationId, additionalInfo: nil)
        ])
    }
}

enum EudiWalletCredentialIssuanceError: Error {
    case template(AlertTemplate)
}
