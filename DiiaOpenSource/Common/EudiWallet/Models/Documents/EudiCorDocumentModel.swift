//
//  EudiCorDocumentModel.swift
//

import Foundation
import MdocDataModel18013

public struct EudiCorDocumentModel: Codable {
    public let id: String
    public let docType: String?
    public let createdAt: Date
    
    // Agreed by the EU
    public let familyName: String?
    public let givenName: String?
    public let birthDate: String?
    public let gender: UInt64?
    public let birthPlace: String?
    public let nationality: String?
    public let issuingAuthority: String?
    public let issuanceDate: String?
    public let administrativeNumber: String?
    public let issuingCountry: String?
    public let expiryDate: String?
    public let issuingJurisdiction: String?
    public let arrivalDate: String?
    
    // Internal
    public let familyNameUa: String?
    public let givenNameUa: String?
    public let middleNameUa: String?
    public let nationalityForDisplay: String?
    public let nationalityForDisplayUa: String?
    public let genderForDisplay: String?
    public let genderForDisplayUa: String?
    public let issuingCountryForDisplayEng: String?
    public let issuingCountryForDisplayUa: String?
    public let fullAddressUa: String?
    public let documentNumber: String?
    
    // residence_address object
    public let residentAddress: String?
//    public let poBox: String?   //po_box
//    public let thoroughfare: String?    //thoroughfare
//    public let locatorDesignator: String?   //locator_designator
//    public let locatorName: String? //locator_name
//    public let postCode: String?    //post_code
//    public let postName: String?    //post_name
//    public let adminUnitL1: String? //admin_unit_L1
//    public let adminUnitL2: String? //admin_unit_L2
//    public let fullAddress: String? //full_address
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case docType
        case createdAt
        case familyName = "family_name"
        case givenName = "given_name"
        case birthDate = "birth_date"
        case residentAddress = "resident_address"
        case gender
        case birthPlace = "birth_place"
        case nationality
        case issuingAuthority = "issuing_authority"
        case issuanceDate = "issuance_date"
        case expiryDate = "expiry_date"
        case documentNumber = "document_number"
        case administrativeNumber = "administrative_number"
        case issuingCountry = "issuing_country"
        case issuingJurisdiction = "issuing_jurisdiction"
        case arrivalDate = "arrival_date"
        
        case familyNameUa = "family_name_ua"
        case givenNameUa = "given_name_ua"
        case middleNameUa = "middle_name_ua"
        case nationalityForDisplay = "nationality_for_display"
        case nationalityForDisplayUa = "nationality_for_display_ua"
        case genderForDisplay = "gender_for_display"
        case genderForDisplayUa = "gender_for_display_ua"
        case issuingCountryForDisplayEng = "issuing_country_for_display_eng"
        case issuingCountryForDisplayUa = "issuing_country_for_display_ua"
        case fullAddressUa = "full_address_ua"
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
        birthPlace = getValue(key: .birthPlace)
        residentAddress = getValue(key: .residentAddress)
        gender = getValue(key: .gender)
        nationality = getValue(key: .nationality)
        issuingAuthority = getValue(key: .issuingAuthority)
        issuanceDate = getValue(key: .issuanceDate)
        expiryDate = getValue(key: .expiryDate)
        documentNumber = getValue(key: .documentNumber)
        administrativeNumber = getValue(key: .administrativeNumber)
        issuingCountry = getValue(key: .issuingCountry)
        issuingJurisdiction = getValue(key: .issuingJurisdiction)
        arrivalDate = getValue(key: .arrivalDate)
        givenNameUa = getValue(key: .givenNameUa)
        familyNameUa = getValue(key: .familyNameUa)
        middleNameUa = getValue(key: .middleNameUa)
        nationalityForDisplay = getValue(key: .nationalityForDisplay)
        nationalityForDisplayUa = getValue(key: .nationalityForDisplayUa)
        genderForDisplay = getValue(key: .genderForDisplay)
        genderForDisplayUa = getValue(key: .genderForDisplayUa)
        issuingCountryForDisplayEng = getValue(key: .issuingCountryForDisplayEng)
        issuingCountryForDisplayUa = getValue(key: .issuingCountryForDisplayUa)
        fullAddressUa = getValue(key: .fullAddressUa)
    }
}
