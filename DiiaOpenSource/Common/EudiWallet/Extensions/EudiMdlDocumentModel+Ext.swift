//
//  EudiMdlDocumentModel+Ext.swift
//  Diia
//
//  Created by Nikita Koruts on 02.04.2025.
//  Copyright © 2025 Diia. All rights reserved.
//

import UIKit
import DiiaCommonTypes
import DiiaUIComponents
import DiiaDocumentsCommonTypes

public extension EudiMdlDocumentModel {
    func fullDocumentModel() -> DSFullDocumentModel {
        let expirationDate = expirationDate()
        let frontCard = frontCardModel()
        
        return DSFullDocumentModel(
            status: .ok,
            expirationDate: expirationDate,
            currentDate: createdAt,
            data: [
                DSDocumentData(
                    docStatus: 200,
                    id: id,
                    docNumber: "",
                    content: [
                        portrait.map { DSDocumentContent(image: $0, code: .photo) }
                    ].compactMap { $0 },
                    docData: DSDocData(
                        docName: "mDL",
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
                    value: "International\nDrivers Licence 🇪🇺",
                    subtitles: nil
                )
            ),
            tableBlockTwoColumnsPlaneOrg: DSTableBlockTwoColumnPlaneOrg(
                photo: .photo,
                items: [
                    birthDate.map {
                        DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Date of birth:",
                            value: $0)
                        )
                    },
                    categories().map {
                        DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Category:",
                            value: $0)
                        )
                    },
                    signatureUsualMark.map {
                        DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            valueImage: DSDocumentContentData(rawValue: $0))
                        )
                    }
                ].compactMap { $0 }
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
                    action: DSActionParameter(type: "ellipseMenu", subtype: "mdl")
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
                        value: "International\nDrivers Licence 🇪🇺",
                        subtitles: ["Ukraine • Україна "]
                    ),
                    docNumberCopyMlc: documentNumber.map {
                        DSTableItemPrimaryMlc(value: $0)
                    }
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
                        birthDate.map {
                            DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Date of birth:",
                                secondaryLabel: "Дата народження",
                                value: $0)
                            )
                        },
                        categories().map {
                            DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Category:",
                                secondaryLabel: "Категорія",
                                value: $0)
                            )
                        },
                        signatureUsualMark.map {
                            DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                valueImage: DSDocumentContentData(rawValue: $0))
                            )
                        }
                    ].compactMap { $0 },
                    headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                        value: name,
                        subtitles: fullname.isEmpty ? nil : [fullname]
                    )
                ))
            ]),
            
            .dictionary([
                "tableBlockOrg": .fromEncodable(encodable: DSTableBlockItemModel(
                    items: [
                        issueDate.map {
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
                                value: $0,
                                secondaryValue: $0)
                            )
                        },
                        unDistinguishingSign.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Distinguishing sign:",
                                secondaryLabel: "Автомобільний код країни",
                                value: $0)
                            )
                        }
                    ].compactMap { $0 }
                ))
            ]),
            
            .dictionary([
                "tableBlockOrg": .fromEncodable(encodable: DSTableBlockItemModel(
                    items: [
                        nationalityForDisplay.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Nationality:",
                                    secondaryLabel: "Громадянство",
                                    value: $0,
                                    secondaryValue: nationalityForDisplayUa)
                                )
                        },
                        genderForDisplay.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Sex:",
                                secondaryLabel: "Стать",
                                value: $0,
                                secondaryValue: genderForDisplayUa)
                            )
                        },
                        birthPlace.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Place of birth:",
                                secondaryLabel: "Місце народження",
                                value: $0,
                                secondaryValue: birthPlaceUa)
                            )
                        },
                        residentAddress.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Residence Address:",
                                secondaryLabel: "Місце проживання",
                                value: $0,
                                secondaryValue: residentAddressUa)
                            )
                        }
                    ].compactMap { $0 }
                ))
            ])
        ]
    }
    
    // MARK: - Helpers
    private var name: String {
        return [givenName, familyName].compactMap { $0 }.joined(separator: " ")
    }
    
    private var fullname: String {
        return [familyName, middleNameUa].compactMap { $0 }.joined(separator: " ")
    }
    
    private func expirationDate() -> Date {
        guard let expiryDate else { return .distantFuture }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: expiryDate) ?? .distantFuture
    }
    
    private func categories() -> String? {
        return drivingPrivileges?.drivingPrivileges.map(\.vehicleCategoryCode).joined(separator: ", ")
    }
}
