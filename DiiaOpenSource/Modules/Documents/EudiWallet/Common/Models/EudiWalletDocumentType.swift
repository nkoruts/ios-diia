//
//  EudiWalletDocumentType.swift
//

import Foundation
import EudiWalletKit
import MdocDataModel18013

enum EudiWalletDocumentType: String, Codable {
    case pid = "eu.europa.ec.eudi.pid.1"
    case mdl = "org.iso.18013.5.1.mDL"
    case cor = "eu.europa.ec.eudi.cor.1"
    
    var issuerId: String {
        switch self {
        case .pid:
            "ec.dev.issuer.eudiw.dev"
        case .mdl:
            "dev.issuer-backend.eudiw.dev"
        case .cor:
            ""
        }
    }
    
    var identifier: String {
        switch self {
        case .pid:
            "eu.europa.ec.eudi.pid_mdoc"
        case .mdl:
            "org.iso.18013.5.1.mDL"
        case .cor:
            ""
        }
    }
}

extension EudiWalletDocumentType {
    var docType: DocType {
        switch self {
        case .pid: .pidDocument
        case .mdl: .mdlDocument
        case .cor: .corDocument
        }
    }
}
