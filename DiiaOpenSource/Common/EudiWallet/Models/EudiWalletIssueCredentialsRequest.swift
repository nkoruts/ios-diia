//
//  EudiWalletIssueCredentialsRequest.swift
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
