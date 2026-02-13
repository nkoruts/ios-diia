//
//  EudiWalletCredentialStoringResult.swift
//

import Foundation

public struct EudiWalletCredentialStoringResult: Codable {
    let event: EudiWalletCredentialStoringEvent
    let notificationId: String
    let eventDescription: String?
    
    public init(
        event: EudiWalletCredentialStoringEvent,
        notificationId: String,
        eventDescription: String? = nil
    ) {
        self.event = event
        self.eventDescription = eventDescription
        self.notificationId = notificationId
    }
}

public enum EudiWalletCredentialStoringEvent: String, Codable {
    case credentialAccepted
    case credentialDeleted
    case credentialFailure
}
