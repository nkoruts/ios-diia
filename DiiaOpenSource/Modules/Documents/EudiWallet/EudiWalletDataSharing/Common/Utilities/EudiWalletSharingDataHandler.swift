//
//  EudiWalletSharingDataHandler.swift
//

import Foundation
import EudiWalletKit
import DiiaCommonTypes
import DiiaUIComponents
import MdocDataTransfer18013

final class EudiWalletSharingDataHandler {
    
    private var docValues: EudiDocValues = [:]
    
    // MARK: - Public Methods
    public func prepareConstructorModel(for request: EudiPresentationRequest) -> DSConstructorModel {
        let displayLabelsBy = parseDisplayLabels()
        docValues = request.items.reduce(into: [:]) { requestedDocs, item in
            guard let document = EudiWalletKitController.instance.fetchDocument(with: item.id),
                  let docElement = item.selectedItemsDictionary.first
            else { return }
            
            let docClaimsValues = Dictionary(uniqueKeysWithValues: document.docClaims.map {
                ($0.name, $0.stringValue)
            })
            requestedDocs[document.id] = docElement.value.reduce(into: [:]) { requestedFields, requestItem in
                let elementIdentifier = requestItem.elementIdentifier
                
                guard let docDisplayName = document.displayName,
                      let valueName = docClaimsValues[elementIdentifier]
                else { return }
                let displayLabel = displayLabelsBy[docDisplayName]?[elementIdentifier]
                let alternativeDisplayName = requestItem.elementPath.first ?? elementIdentifier
                requestedFields[elementIdentifier] = EudiDocItemValue(
                    namespace: docElement.key,
                    docType: item.docTypeOrVct,
                    isOptional: requestItem.isOptional ?? true,
                    displayName: EudiDocItemDisplayName(
                        en: displayLabel?.sharingENDisplayLabel ?? alternativeDisplayName,
                        ua: displayLabel?.sharingUADisplayLabel ?? nil
                    ),
                    valueName: valueName
                )
            }
        }
        
        let requestAdapter = EudiWalletDisclosureRequestAdapter(
            relyingParty: request.relyingParty,
            docValues: docValues
        )
        return requestAdapter.getContructorModel()
    }
    
    public func transformAnyCodableToRequest(input: [String: AnyCodable]) -> RequestItems {
        return input.reduce(into: [:]) { partialResult, inputItem in
            guard case let .bool(isSelected) = inputItem.value, isSelected else { return }
            let components = inputItem.key.components(separatedBy: "/")
            guard let elementIdentifier = components.first,
                  let docNumber = components.last,
                  let element = docValues[docNumber]?[elementIdentifier]
            else { return }
            let requestItem = RequestItem(elementIdentifier: elementIdentifier)
            partialResult[docNumber, default: [:]][element.namespace, default: []].append(requestItem)
        }
    }
    
    public func getDocItem(by docId: String, elementIdentifier: String) -> EudiDocItemValue? {
        return docValues[docId]?[elementIdentifier]
    }
    
    // MARK: - Private Methods
    private func parseDisplayLabels() -> EudiWalletDisclosureDisplayLabels {
        guard let filePath = Bundle.main.url(
            forResource: "ewallet_verification_display_labels",
            withExtension: "json"
        ) else { return [:] }
        
        do {
            let data = try Data(contentsOf: filePath)
            return try JSONDecoder().decode(EudiWalletDisclosureDisplayLabels.self, from: data)
        } catch {
            return [:]
        }
    }
}
