//
//  EudiWalletKitAPI.swift
//  Diia
//
//  Created by Nikita Koruts on 07.11.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import DiiaNetwork
import EudiWalletKit
import DiiaCommonTypes

enum EudiWalletKitAPI: CommonService {
    case getCredentialIssuingConfiguration
    case getCredentials(requestModel: DocIssuanceRequest)
    case sendCredentialStoringResult(requestModel: EudiWalletCredentialStoringResult)
    
    var method: HTTPMethod {
        switch self {
        case .getCredentialIssuingConfiguration:
            return .get
        case .getCredentials, .sendCredentialStoringResult:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getCredentialIssuingConfiguration:
            return "v1/.well-known/openid-credential-issuer"
        case .getCredentials:
            return "v3/wallet/credentialEndpoint"
        case .sendCredentialStoringResult:
            return "v1/wallet/notificationEndpoint"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getCredentials(let requestModel):
            return requestModel.dictionary
        case .sendCredentialStoringResult(let requestModel):
            return requestModel.dictionary
        default:
            return nil
        }
    }
    
    var analyticsName: String {
        switch self {
        case .getCredentialIssuingConfiguration:
            return NetworkActionKey.eudiWalletGetCredentialIssuingConfiguration.rawValue
        case .getCredentials:
            return NetworkActionKey.eudiWalletGetCredentials.rawValue
        case .sendCredentialStoringResult:
            return NetworkActionKey.eudiWalletSendCredentialStoringResult.rawValue
        }
    }
}
