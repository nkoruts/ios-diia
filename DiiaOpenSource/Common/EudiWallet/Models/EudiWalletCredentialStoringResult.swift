//
//  EudiWalletCredentialStoringResult.swift
//  Diia
//
//  Created by Nikita Koruts on 25.06.2025.
//  Copyright © 2025 Diia. All rights reserved.
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
