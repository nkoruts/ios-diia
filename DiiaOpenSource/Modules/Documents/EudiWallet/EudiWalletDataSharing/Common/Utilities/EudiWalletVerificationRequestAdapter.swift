//
//  EudiWalletDisclosureRequestAdapter.swift
//

import Foundation
import EudiWalletKit
import DiiaCommonTypes
import DiiaUIComponents
import MdocDataModel18013

typealias EudiWalletDisclosureDisplayLabels = [String: [String: EudiWalletDisclosureDisplayItem]]

public struct EudiWalletDisclosureDisplayItem: Decodable {
    let sharingENDisplayLabel: String
    let sharingUADisplayLabel: String
}

public struct EudiWalletDisclosureRequestAdapter {
    private let relyingParty: String
    private let docValues: EudiDocValues
    
    init(relyingParty: String, docValues: EudiDocValues) {
        self.relyingParty = relyingParty
        self.docValues = docValues
    }
    
    public func getContructorModel() -> DSConstructorModel {
        return DSConstructorModel(
            topGroup: topGroup(),
            body: body(),
            bottomGroup: bottomGroup()
        )
    }
    
    // MARK: - Private Methods
    private func topGroup() -> [AnyCodable] {
        return [
            .dictionary(["topGroupOrg": .fromEncodable(encodable: DSTopGroupOrg(
                navigationPanelMlc: .init(label: "Поширення даних", ellipseMenu: nil))
            )])
        ]
    }
    
    private func body() -> [AnyCodable] {
        return docValues.reduce(into: [
            .dictionary(["titleLabelMlc": .fromEncodable(
                encodable: DSTitleLabelMlc(
                    label: "Запит на цифрові дані",
                    componentId: nil
                )
            )]),
            .dictionary(["textLabelMlc": .fromEncodable(
                encodable: DSTextContainerData(
                    componentId: nil,
                    text: "\(relyingParty) просить надати дані для укладання договору:",
                    label: nil
                )
            )])
        ]) { partialResult, docValue in
            partialResult.append(mapToBackgroundWhiteOrg(
                docNumber: docValue.key,
                docItems: docValue.value
            ))
        }
    }
        
    private func bottomGroup() -> [AnyCodable] {
        return [
            .dictionary(["btnPrimaryDefaultAtm": .fromEncodable(
                encodable: DSButtonModel(
                    label: "Поширити дані",
                    action: .init(type: "send_selective_disclosure"),
                    componentId: nil
                )
            )])
        ]
    }
    
    private func mapToBackgroundWhiteOrg(
        docNumber: String,
        docItems: [String: EudiDocItemValue]
    ) -> AnyCodable {
        let items: [AnyCodable] = docItems.reduce(into: [
            .dictionary(["tableMainHeadingMlc": .fromEncodable(
                encodable: DSTableHeadingItemModel(
                    label: documentName(for: docItems.first?.value.docType)
                )
            )])
        ]) { partialResult, docItem in
            partialResult.append(mapToTableItemCheckboxMlc(
                docNumber: docNumber,
                elementIdentifier: docItem.key,
                docItem: docItem.value
            ))
        }
        return .dictionary(["backgroundWhiteOrg": .fromEncodable(
            encodable: DSBackgroundWhiteOrgModel(
                componentId: UUID().uuidString,
                id: "",
                items: items
            )
        )])
    }
    
    private func mapToTableItemCheckboxMlc(
        docNumber: String,
        elementIdentifier: String,
        docItem: EudiDocItemValue
    ) -> AnyCodable {
        return .dictionary(["tableItemCheckboxMlc": .fromEncodable(
            encodable: DSTableItemCheckboxModel(
                componentId: nil,
                inputCode: elementIdentifier + "/" + docNumber,
                mandatory: false,
                rows: [
                    DSTableItemCheckboxRowModel(
                        textLabelAtm: DSTextLabelAtmModel(
                            mode: .primary,
                            label: docItem.displayName.en + (docItem.isOptional ? "" : "*"),
                            value: docItem.valueName
                        )
                    ),
                    docItem.displayName.ua.map {
                        DSTableItemCheckboxRowModel(
                            textLabelAtm: DSTextLabelAtmModel(
                                mode: .secondary,
                                label: $0,
                                value: nil
                            )
                        )
                    }
                ].compactMap { $0 },
                isSelected: true,
                isNotFullSelected: nil,
                dataJson: nil
            )
        )])
    }
    
    private func documentName(for docType: String?) -> String {
        switch docType {
        case "eu.europa.ec.eudi.pid.1", "urn:eudi:pid:1":
            return DocType.pidDocument.name
        case "org.iso.18013.5.1.mDL":
            return DocType.mdlDocument.name
        case "eu.europa.ec.eudi.cor.1":
            return DocType.corDocument.name
        default:
            return "Unknown document"
        }
    }
}
