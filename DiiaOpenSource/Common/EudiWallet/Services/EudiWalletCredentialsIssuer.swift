//
//  EudiWalletCredentialsIssuer.swift
//  Diia
//
//  Created by Nikita Koruts on 08.11.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import Foundation
import OpenID4VCI
import ReactiveKit
import DiiaNetwork
import EudiWalletKit
import DiiaCommonTypes
import MdocDataModel18013

public class EudiWalletCredentialsIssuer {
    
    private let apiClient = EudiWalletKitAPIClient()
    private let bag = DisposeBag()
    private var didRetry = false

    // MARK: - Public Methods
    public func loadIssuerMetadata() async throws -> CredentialIssuerMetadata {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.getCredentialIssuingConfiguration().observe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let response):
                    self.didRetry = false
                    continuation.resume(returning: response)
                case .failed(let error):
                    continuation.resume(throwing: error)
                default:
                    break
                }
            }
            .dispose(in: bag)
        }
    }
    
    public func issueCredentials(for request: DocIssuanceRequest) async throws -> EudiWalletCredentialIssuanceResponse {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.getCredentials(request).observe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let response):
                    self.didRetry = false
                    continuation.resume(returning: response)
                case .failed(let error):
                    continuation.resume(throwing: error)
                default:
                    break
                }
            }
            .dispose(in: bag)
        }
    }
    
    public func sendCredentialStoringResult(_ result: EudiWalletCredentialStoringResult) async throws -> TemplatedResponse<ProcessCodeResponse> {
        return try await withCheckedThrowingContinuation { continuation in
            apiClient.sendCredentialStoringResult(result).observe { [weak self] event in
                guard let self else { return }
                switch event {
                case .next(let response):
                    self.didRetry = false
                    continuation.resume(returning: response)
                case .failed(let error):
                    continuation.resume(throwing: error)
                default:
                    break
                }
            }
            .dispose(in: bag)
        }
    }
}
