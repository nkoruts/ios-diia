//
//  EudiCorDocumentModel+Ext.swift
//  Diia
//
//  Created by Nikita Koruts on 02.04.2025.
//  Copyright © 2025 Diia. All rights reserved.
//

import UIKit
import DiiaCommonTypes
import DiiaUIComponents
import DiiaDocumentsCommonTypes

public extension EudiCorDocumentModel {
    func fullDocumentModel() -> DSFullDocumentModel {
        let frontCard = frontCardModel()
        return DSFullDocumentModel(
            status: .ok,
            expirationDate: .distantFuture,
            currentDate: createdAt,
            data: [
                DSDocumentData(
                    docStatus: 200,
                    id: id,
                    qr: nil,
                    docNumber: documentNumber ?? .empty,
                    docData: DSDocData(
                        docName: "CoR",
                        docType: docType
                    ),
                    frontCard: DSDocumentFrontCard(
                        UA: [frontCard],
                        EN: [frontCard]
                    ),
                    fullInfo: fullInfo()
                )
            ]
        )
    }
    
    // MARK: - Front Model
    private func frontCardModel() -> DSDocumentModel {
        DSDocumentModel(
            docHeadingOrg: DSDocumentHeading(
                headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                    value: "Certificate\nof Residence 🇪🇺",
                    subtitles: nil
                )
            ),
            tableBlockPlaneOrg: DSTableBlockItemModel(
                tableMainHeadingMlc: DSTableHeadingItemModel(
                    label: name,
                    icon: nil
                ),
                items: [
                    residentAddress.map {
                        DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Residence Address:",
                            value: $0
                        ))
                    },
                    issuanceDate.map {
                        DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Date of issue",
                            value: $0
                        ))
                    }
                ].compactMap(\.self)
            ),
            tickerAtm: DSTickerAtom(
                usage: .document,
                type: .cyan,
                value: "Document valid until \(expiryDate ?? "") • Документ дійсний до \(expiryDate ?? "") • "
            ),
            docButtonHeadingOrg: DSDocumentHeading(
                docNumberCopyMlc: DSTableItemPrimaryMlc(value: documentNumber ?? .empty),
                iconAtm: DSIconModel(
                    code: "ellipseKebab",
                    action: DSActionParameter(type: "ellipseMenu", subtype: "cor")
                )
            )
        )
    }
    
    // MARK: - Full Info
    private func fullInfo() -> [AnyCodable] {
        return [
            .dictionary([
                "docHeadingOrg": .fromEncodable(encodable: DSDocumentHeading(
                    headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                        value: "Certificate\nof Residence 🇪🇺",
                        subtitles: ["Ukraine • Україна "]
                    ),
                    docNumberCopyMlc: DSTableItemPrimaryMlc(value: documentNumber ?? .empty)
                ))
            ]),
            
            .dictionary([
                "tickerAtm": .fromEncodable(encodable: DSTickerAtom(
                    usage: .document,
                    type: .cyan,
                    value: "Document valid until \(expiryDate ?? "") • Документ дійсний до \(expiryDate ?? "") • "
                ))
            ]),
            
            .dictionary([
                "tableBlockTwoColumnsOrg": .fromEncodable(encodable: DSTableBlockTwoColumnPlaneOrg(
                    photo: .photo,
                    items: [
                        nationalityForDisplay.map {
                            DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Nationality:",
                                secondaryLabel: "Громадянство",
                                value: $0,
                                secondaryValue: nationalityForDisplayUa
                            ))
                        },
                        genderForDisplay.map {
                            DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Sex:",
                                secondaryLabel: "Стать",
                                value: $0,
                                secondaryValue: genderForDisplayUa
                            ))
                        },
                        birthDate.map {
                            DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Date of birth:",
                                secondaryLabel: "Дата народження",
                                value: $0
                            ))
                        }
                    ].compactMap(\.self),
                    headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                        value: name,
                        subtitles: fullname.isEmpty ? nil : [fullname]
                    )
                ))
            ]),
            
            .dictionary([
                "tableBlockOrg": .fromEncodable(encodable: DSTableBlockItemModel(
                    items: [
                        issuanceDate.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Date of issue:",
                                secondaryLabel: "Дата видачі",
                                value: $0)
                            )
                        },
                        expiryDate.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Date of expiry:",
                                secondaryLabel: "Дата строку дії",
                                value: $0)
                            )
                        },
                        issuingAuthority.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Authority:",
                                secondaryLabel: "Інстанція",
                                value: $0)
                            )
                        },
                        issuingCountry.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Issuing country:",
                                secondaryLabel: "Країна видачі",
                                value: $0)
                            )
                        }
                    ].compactMap(\.self)
                ))
            ]),
            
            .dictionary([
                "tableBlockOrg": .fromEncodable(encodable: DSTableBlockItemModel(
                    items: [
                        residentAddress.map {
                            DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Residence Address:",
                                secondaryLabel: "Місце проживання",
                                value: $0)
                            )
                        },
                        DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Arrival date:",
                            secondaryLabel: "Дата заселення",
                            value: arrivalDate
                        ))
                    ].compactMap(\.self)
                ))
            ])
        ]
    }
    
    // MARK: - Helpers
    private var name: String {
        return [givenName, familyName].compactMap(\.self).joined(separator: " ")
    }
    
    private var fullname: String {
        return [familyNameUa, givenNameUa, middleNameUa].compactMap(\.self).joined(separator: " ")
    }
}
