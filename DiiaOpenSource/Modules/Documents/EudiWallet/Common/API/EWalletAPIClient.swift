//
//  EWalletAPIClient.swift
//

import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices
import DiiaUIComponents

protocol EWalletAPIClientProtocol {
    func getOnboarding(documentType: EudiWalletDocumentType) -> Signal<DSConstructorModel, NetworkError>
}

class EWalletAPIClient: ApiClient<EWalletAPI>, EWalletAPIClientProtocol {

    func getOnboarding(documentType: EudiWalletDocumentType) -> Signal<DSConstructorModel, NetworkError> {
        return request(.getOnboarding(documentType: documentType))
    }
}
