//
//  EudiPresentationRequest.swift
//

import Foundation
import EudiWalletKit

public struct EudiPresentationRequest: Sendable {
    public let items: [DocElements]
    public let relyingParty: String
    public let dataRequestInfo: String
    public let isTrusted: Bool
}
