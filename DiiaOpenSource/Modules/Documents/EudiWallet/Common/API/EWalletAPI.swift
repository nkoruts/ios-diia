//
//  EWalletAPI.swift
//

import Foundation
import DiiaNetwork
import DiiaCommonTypes

enum EWalletAPI: CommonService {
    case getOnboarding(documentType: EudiWalletDocumentType)
    
    var method: HTTPMethod {
        switch self {
        case .getOnboarding:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getOnboarding:
            return "v1/documents/e-wallet/onboarding"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getOnboarding(let documentType):
            return ["documentType": documentType]
        }
    }
    
    var analyticsName: String { .empty }
}
