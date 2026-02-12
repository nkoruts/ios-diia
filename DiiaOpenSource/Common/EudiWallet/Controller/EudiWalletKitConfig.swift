//
//  EudiWalletKitConfig.swift
//  Diia
//
//  Created by Nikita Koruts on 28.10.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import Foundation
import EudiWalletKit

struct EudiWalletKitConfig {
    
    var userAuthenticationRequired = false
    
    var vpConfig: OpenId4VpConfiguration {
      .init(clientIdSchemes: [.x509SanDns, .x509Hash])
    }
    
    var vciConfig: [String: OpenId4VciConfiguration] {
        return [
            "api2t.diia.gov.ua": OpenId4VciConfiguration(
                credentialIssuerURL: "https://api2t.diia.gov.ua/api/v1/wallet",
                clientId: "wallet-dev",
                authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")
            ),
            "ec.dev.issuer.eudiw.dev": OpenId4VciConfiguration(
                credentialIssuerURL: "https://ec.dev.issuer.eudiw.dev",
                clientId: "wallet-dev",
                authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")
            ),
            "dev.issuer-backend.eudiw.dev": OpenId4VciConfiguration(
              credentialIssuerURL: "https://dev.issuer-backend.eudiw.dev",
              clientId: "wallet-dev",
              authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")
            )
        ]
    }
    
    var serviceName: String {
        guard let identifier = Bundle.main.bundleIdentifier else {
            return "eudi.document.storage"
        }
        return "\(identifier).eudi.document.storage"
    }
    
    var trustedCerts: [Data] {
        return [
            Data(name: "pidissuerca02_cz", ext: "der"),
            Data(name: "pidissuerca02_ee", ext: "der"),
            Data(name: "pidissuerca02_eu", ext: "der"),
            Data(name: "pidissuerca02_lu", ext: "der"),
            Data(name: "pidissuerca02_nl", ext: "der"),
            Data(name: "pidissuerca02_pt", ext: "der"),
            Data(name: "pidissuerca02_u", ext: "der"),
            Data(name: "pidissuerca02_cz", ext: "der"),
            Data(name: "pidissuerca02_ee", ext: "der"),
            Data(name: "esoz_cert", ext: "der")
        ].compactMap { $0 }
    }
}
