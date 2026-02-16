//
//  EudiWalletDeeplinkRouteBuilder.swift
//

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

public struct EudiWalletDeeplinkRouteBuilder {
    
    public let needAuth = true
    
    private let sharingSchemes: Set<String> = [
        "eudi-openid4vp",
        "mdoc-openid4vp",
        "mdl-openid4vp",
        "openid4vp",
        "haip-vp",
        "haip",
    ]
    
    private let issuanceSchemes: Set<String> = [
        "openid-credential-offer",
        "haip-vci"
    ]
    
    public func create(with urlString: String) -> RouterProtocol? {
        guard let scheme = URL(string: urlString)?.scheme else { return nil }
        
        if sharingSchemes.contains(scheme) {
            return EudiWalletSharingDeeplinkRouter(urlString: urlString)
        }
        if issuanceSchemes.contains(scheme) {
            return EudiWalletIssuanceDeeplinkRouter(urlString: urlString)
        }
        
        return nil
    }
}

struct EudiWalletSharingDeeplinkRouter: RouterProtocol {
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func route(in view: BaseView) {
        let urlStringWithoutScheme = stripScheme(from: urlString)
        let module = EudiWalletRemoteSharingModule(link: urlStringWithoutScheme)
        view.open(module: module)
    }
    
    private func stripScheme(from link: String) -> String {
        guard let range = link.range(of: "://") else { return link }
        return String(link[range.upperBound...])
    }
}

struct EudiWalletIssuanceDeeplinkRouter: RouterProtocol {
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func route(in view: BaseView) {
        let module = EudiDocumentIssuanceModule(offerUri: urlString)
        view.open(module: module)
    }
}
