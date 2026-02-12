//
//  EudiWalletIssueCredentialsRequest.swift
//  Diia
//
//  Created by Nikita Koruts on 07.11.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import Foundation

struct EudiWalletIssueCredentialsRequest: Codable {
    let doctype: String
    let proofs: [EudiWalletIssueCredentialsProof]
}

struct EudiWalletIssueCredentialsProof: Codable {
    let jwt: String
    let proofType: String
    let format: String
}
