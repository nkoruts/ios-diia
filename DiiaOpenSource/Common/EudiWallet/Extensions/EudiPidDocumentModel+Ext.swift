//
//  EudiPidDocumentModel+Ext.swift
//  Diia
//
//  Created by Nikita Koruts on 01.04.2025.
//  Copyright © 2025 Diia. All rights reserved.
//

import UIKit
import DiiaCommonTypes
import DiiaUIComponents
import DiiaDocumentsCommonTypes

public extension EudiPidDocumentModel {
    func fullDocumentModel() -> DSFullDocumentModel {
        let frontCard = frontCardModel()
        
        return DSFullDocumentModel(
            status: .ok,
            expirationDate: expirationDate(),
            currentDate: createdAt,
            data: [
                DSDocumentData(
                    docStatus: 200, // TODO: - Handle docStatus (expirationDate logic)
                    id: id,
                    docNumber: documentNumber ?? .empty,
                    content: [
                        portrait.map { DSDocumentContent(image: $0, code: .photo) }
                    ].compactMap { $0 },
                    docData: DSDocData(
                        docName: "PID",
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
    
    // MARK: - Front Card
    private func frontCardModel() -> DSDocumentModel {
        DSDocumentModel(
            docHeadingOrg: DSDocumentHeading(
                headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                    value: "National ID\nof Ukraine 🇪🇺",
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
                    nationalityForDisplay.map {
                        DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Nationality:",
                            value: $0)
                        )
                    },
                    signature.map {
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
                headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                    value: name,
                    subtitles: fullname.isEmpty ? nil : [fullname]
                ),
                iconAtm: DSIconModel(
                    code: "ellipseKebab",
                    action: DSActionParameter(type: "ellipseMenu", subtype: "pid")
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
                        value: "National ID\nof Ukraine 🇪🇺",
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
                        DSItemsModel(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: (ageOver18 ?? true ? "Over" : "Under") + " 18 y.o",
                            secondaryLabel: (ageOver18 ?? true ? "Старше" : "Немає") + " 18 років")
                        ),
                        signature.map {
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
                        DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                            label: "Nationality:",
                            secondaryLabel: "Громадянство",
                            value: nationalityForDisplay,
                            secondaryValue: nationalityForDisplayUa)
                        ),
                        genderForDisplay.map {
                            DSTableItem(tableItemHorizontalMlc: DSTableItemHorizontalMlc(
                                label: "Sex:",
                                secondaryLabel: "Стать",
                                value: $0,
                                secondaryValue: genderForDisplayUa)
                            )
                        },
                        nameBirth.map {
                            DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Birth name:",
                                secondaryLabel: "Імʼя при народжені",
                                value: $0,
                                secondaryValue: fullnameBirth)
                            )
                        },
                        personalAdministrativeNumber.map {
                            DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                                label: "Personal administrative number:",
                                secondaryLabel: "УНЗР",
                                value: $0)
                            )
                        }
                    ].compactMap { $0 }
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
                                value: $0,
                                secondaryValue: $0)
                            )
                        }
                    ].compactMap { $0 }
                ))
            ]),
            
            .dictionary([
                "tableBlockOrg": .fromEncodable(encodable: DSTableBlockItemModel(
                    items: [
                        DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Residence Address:",
                            secondaryLabel: "Місце проживання",
                            value: residentAddress,
                            secondaryValue: residentAddressUa)
                        ),
                        DSTableItem(tableItemVerticalMlc: DSTableItemVerticalMlc(
                            label: "Place of birth:",
                            secondaryLabel: "Місце народження",
                            value: birthPlace,
                            secondaryValue: nil)
                        )
                    ]
                ))
            ])
        ]
    }
    
    // MARK: - Helpers
    private var name: String {
        return [givenName, familyName].compactMap { $0 }.joined(separator: " ")
    }
    
    private var fullname: String {
        return [familyNameUa, givenNameUa, middleNameUa].compactMap { $0 }.joined(separator: " ")
    }
    
    private var nameBirth: String? {
        let name = [givenNameBirth, familyNameBirth].compactMap { $0 }
        return name.isEmpty ? nil : name.joined(separator: " ")
    }
    
    private var fullnameBirth: String? {
        let fullname = [familyNameBirthUa, givenNameBirthUa, middleNameBirthUa].compactMap { $0 }
        return fullname.isEmpty ? nil : fullname.joined(separator: " ")
    }
    
    private func expirationDate() -> Date {
        guard let expiryDate else { return .distantFuture }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: expiryDate) ?? .distantFuture
    }
}
