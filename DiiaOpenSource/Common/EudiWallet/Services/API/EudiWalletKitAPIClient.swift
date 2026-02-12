//
//  EudiWalletKitAPIClient.swift
//  Diia
//
//  Created by Nikita Koruts on 07.11.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import OpenID4VCI
import ReactiveKit
import DiiaNetwork
import EudiWalletKit
import DiiaCommonTypes

protocol EudiWalletKitAPIClientProtocol {
    func getCredentialIssuingConfiguration() -> Signal<CredentialIssuerMetadata, NetworkError>
    func getCredentials(_ requestModel: DocIssuanceRequest) -> Signal<EudiWalletCredentialIssuanceResponse, NetworkError>
    func sendCredentialStoringResult(_ requestModel: EudiWalletCredentialStoringResult) -> Signal<TemplatedResponse<ProcessCodeResponse>, NetworkError>
}

class EudiWalletKitAPIClient: ApiClient<EudiWalletKitAPI>, EudiWalletKitAPIClientProtocol {
    func getCredentialIssuingConfiguration() -> Signal<CredentialIssuerMetadata, NetworkError> {
        return request(.getCredentialIssuingConfiguration)
    }
    
    func getCredentials(_ requestModel: DocIssuanceRequest) -> Signal<EudiWalletCredentialIssuanceResponse, NetworkError> {
        return request(.getCredentials(requestModel: requestModel))
    }
    
    func sendCredentialStoringResult(_ requestModel: EudiWalletCredentialStoringResult) -> Signal<TemplatedResponse<ProcessCodeResponse>, NetworkError> {
        return request(.sendCredentialStoringResult(requestModel: requestModel))
    }
}
