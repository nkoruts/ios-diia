//
//  EudiPidDocumentModel.swift
//  Diia
//
//  Created by Nikita Koruts on 30.10.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import Foundation
import MdocDataModel18013

public struct EudiPidDocumentModel: Codable {
    public let id: String
    public let docType: String?
    public let createdAt: Date
    
    // Agreed by the EU
    public let familyName: String?
    public let givenName: String?
    public let birthDate: String?
    public let birthPlace: String?
    public let birthCountry: String?
    public let birthState: String?
    public let birthCity: String?
    public let sex: UInt64?
    public let nationality: String?
    public let ageOver18: Bool?
    public let ageInYears: UInt64?
    public let ageBirthYear: UInt64?
    public let expiryDate: String?
    public let issuingAuthority: String?
    public let issuanceDate: String?
    public let documentNumber: String?
    public let administrativeNumber: String?
    public let issuingCountry: String?
    public let issuingJurisdiction: String?
    
    // Internal fields
    public let familyNameUa: String?
    public let givenNameUa: String?
    public let middleNameUa: String?
    public let residentAddressUa: String?
    public let familyNameBirthUa: String?
    public let givenNameBirthUa: String?
    public let middleNameBirthUa: String?
    public let birthPlaceUa: String?
    public let genderForDisplay: String?
    public let genderForDisplayUa: String?
    public let nationalityForDisplayUa: String?
    public let nationalityForDisplay: String?
    public let personalAdministrativeNumber: String?
    public let familyNameBirth: String?
    public let givenNameBirth: String?
    public let residentAddress: String?
    public let residentCity: String?
    public let residentPostalCode: String?
    public let residentState: String?
    public let residentCountry: String?
    public let residentStreet: String?
    public let residentHouseNumber: String?
    public let portrait: String?
    public let signature: String?
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case docType
        case createdAt
        case familyName = "family_name"
        case givenName = "given_name"
        case birthDate = "birth_date"
        case familyNameBirth = "family_name_birth"
        case givenNameBirth = "given_name_birth"
        case birthPlace = "birth_place"
        case birthCountry = "birth_country"
        case birthState = "birth_state"
        case birthCity = "birth_city"
        case residentAddress = "resident_address"
        case residentCity = "resident_city"
        case residentPostalCode = "resident_postal_code"
        case residentState = "resident_state"
        case residentCountry = "resident_country"
        case residentStreet = "resident_street"
        case residentHouseNumber = "resident_house_number"
        case sex
        case nationality
        case ageOver18 = "age_over_18"
        case ageInYears = "age_in_years"
        case ageBirthYear = "age_birth_year"
        case expiryDate = "expiry_date"
        case issuingAuthority = "issuing_authority"
        case issuanceDate = "issuance_date"
        case documentNumber = "document_number"
        case administrativeNumber = "administrative_number"
        case issuingCountry = "issuing_country"
        case issuingJurisdiction = "issuing_jurisdiction"
        case portrait
        case signature
        
        case givenNameUa = "given_name_ua"
        case familyNameUa = "family_name_ua"
        case middleNameUa = "middle_name_ua"
        case familyNameBirthUa = "family_name_birth_ua"
        case givenNameBirthUa = "given_name_birth_ua"
        case middleNameBirthUa = "middle_name_birth_ua"
        case residentAddressUa = "resident_address_ua"
        case birthPlaceUa = "birth_place_ua"
        case genderForDisplay = "gender_for_display"
        case genderForDisplayUa = "gender_for_display_ua"
        case nationalityForDisplay = "nationality_for_display"
        case nationalityForDisplayUa = "nationality_for_display_ua"
        case personalAdministrativeNumber = "personal_administrative_number"
    }
    
    init(_ docModel: DocClaimsDecodable) {
        let docKeyValues = docModel.docClaims.map { ($0.name, $0.dataValue) }
        let docFields = Dictionary(uniqueKeysWithValues: docKeyValues)
        func getValue<T>(key: CodingKeys) -> T? {
            return docFields[key.rawValue]?.getValue()
        }
        
        id = docModel.id
        docType = docModel.docType
        createdAt = Date()
        familyName = getValue(key: .familyName)
        givenName = getValue(key: .givenName)
        birthDate = getValue(key: .birthDate)
        familyNameBirth = getValue(key: .familyNameBirth)
        givenNameBirth = getValue(key: .givenNameBirth)
        birthPlace = getValue(key: .birthPlace)
        birthCountry = getValue(key: .birthCountry)
        birthState = getValue(key: .birthState)
        birthCity = getValue(key: .birthCity)
        residentAddress = getValue(key: .residentAddress)
        residentCity = getValue(key: .residentCity)
        residentPostalCode = getValue(key: .residentPostalCode)
        residentState = getValue(key: .residentState)
        residentCountry = getValue(key: .residentCountry)
        residentStreet = getValue(key: .residentStreet)
        residentHouseNumber = getValue(key: .residentHouseNumber)
        sex = getValue(key: .sex)
        nationality = getValue(key: .nationality)
        ageOver18 = getValue(key: .ageOver18)
        ageInYears = getValue(key: .ageInYears)
        ageBirthYear = getValue(key: .ageBirthYear)
        expiryDate = getValue(key: .expiryDate)
        issuingAuthority = getValue(key: .issuingAuthority)
        issuanceDate = getValue(key: .issuanceDate)
        documentNumber = getValue(key: .documentNumber)
        administrativeNumber = getValue(key: .administrativeNumber)
        issuingCountry = getValue(key: .issuingCountry)
        issuingJurisdiction = getValue(key: .issuingJurisdiction)
        givenNameUa = getValue(key: .givenNameUa)
        familyNameUa = getValue(key: .familyNameUa)
        middleNameUa = getValue(key: .middleNameUa)
        residentAddressUa = getValue(key: .residentAddressUa)
        familyNameBirthUa = getValue(key: .familyNameBirthUa)
        givenNameBirthUa = getValue(key: .givenNameBirthUa)
        middleNameBirthUa = getValue(key: .middleNameBirthUa)
        birthPlaceUa = getValue(key: .birthPlaceUa)
        genderForDisplay = getValue(key: .genderForDisplay)
        genderForDisplayUa = getValue(key: .genderForDisplayUa)
        nationalityForDisplay = getValue(key: .nationalityForDisplay)
        nationalityForDisplayUa = getValue(key: .nationalityForDisplayUa)
        personalAdministrativeNumber = getValue(key: .personalAdministrativeNumber)
        
        if let portraitValue: [UInt8] = getValue(key: .portrait) {
            portrait = Data(portraitValue).base64EncodedString()
        } else {
            portrait = nil
        }
        if let signatureValue: [UInt8] = getValue(key: .signature) {
            signature = Data(signatureValue).base64EncodedString()
        } else {
            signature = nil
        }
    }
}
