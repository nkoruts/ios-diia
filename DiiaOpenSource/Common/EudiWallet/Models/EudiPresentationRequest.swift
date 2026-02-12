//
//  EudiPresentationRequest.swift
//  Diia
//
//  Created by Nikita Koruts on 27.11.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import Foundation
import EudiWalletKit

public struct EudiPresentationRequest: Sendable {
    public let items: [DocElements]
    public let relyingParty: String
    public let dataRequestInfo: String
    public let isTrusted: Bool
}
