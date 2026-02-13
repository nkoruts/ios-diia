//
//  EudiMdlDocumentModel.swift
//

import Foundation
import MdocDataModel18013

public struct EudiMdlDocumentModel: Codable {
    public let id: String
    public let docType: String?
    public let createdAt: Date
    
    // Agreed by the EU
    public let familyName: String?
    public let givenName: String?
    public let birthDate: String?
    public let birthPlace: String?
    public let issueDate: String?
    public let expiryDate: String?
    public let issuingCountry: String?
    public let issuingAuthority: String?
    public let documentNumber: String?
    public let administrativeNumber: String?
    public var drivingPrivileges: DrivingPrivileges?
    public let nationality: String?
    public let eyeColour: String?
    public let hairColour: String?
    public let height: UInt64?
    public let weight: UInt64?
    public let sex: UInt64?
    public let residentAddress: String?
    public let residentCountry: String?
    public let residentCity: String?
    public let residentState: String?
    public let residentPostalCode: String?
    public let ageOver18: String?
    public let ageInYears: UInt64?
    public var ageOverXX = [Int: Bool]()
    public let ageBirthYear: UInt64?
    public let portrait: String?
    public let unDistinguishingSign: String?
    public let issuingJurisdiction: String?
    public let portraitCaptureDate: String?
    public let familyNameNationalCharacter: String?
    public let givenNameNationalCharacter: String?
    public let signatureUsualMark: String?
    public let biometricTemplateFace: String?
    public let biometricTemplateSignatureSign: String?
    
    // MARK: - Internal fields
    public let middleNameUa: String?
    public let issuingCountryForDisplayEng: String?
    public let issuingCountryForDisplayUa: String?
    public let nationalityForDisplayUa: String?
    public let nationalityForDisplay: String?
    public let genderForDisplay: String?
    public let genderForDisplayUa: String?
    public let residentAddressUa: String?
    public let birthPlaceUa: String?
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case docType
        case createdAt
        case familyName = "family_name"
        case givenName = "given_name"
        case birthDate = "birth_date"
        case birthPlace = "birth_place"
        case issueDate = "issue_date"
        case expiryDate = "expiry_date"
        case issuingCountry = "issuing_country"
        case issuingAuthority = "issuing_authority"
        case documentNumber = "document_number"
        case administrativeNumber = "administrative_number"
        case drivingPrivileges = "driving_privileges"
        case unDistinguishingSign = "un_distinguishing_sign"
        case nationality = "nationality"
        case eyeColour = "eye_colour"
        case hairColour = "hair_colour"
        case height = "height"
        case weight = "weight"
        case sex = "sex"
        case residentAddress = "resident_address"
        case residentCity = "resident_city"
        case residentState = "resident_state"
        case residentPostalCode = "resident_postal_code"
        case residentCountry = "resident_country"
        case ageOver18 = "age_over_18"
        case ageInYears = "age_in_years"
        case ageBirthYear = "age_birth_year"
        case portrait = "portrait"
        case issuingJurisdiction = "issuing_jurisdiction"
        case portraitCaptureDate = "portrait_capture_date"
        case familyNameNationalCharacter = "family_name_national_character"
        case givenNameNationalCharacter = "given_name_national_character"
        case signatureUsualMark = "signature_usual_mark"
        case biometricTemplateFace = "biometric_template_face"
        case biometricTemplateSignatureSign = "biometric_template_signature_sign"
        
        case middleNameUa = "middle_name_ua"
        case issuingCountryForDisplayEng = "issuing_country_for_display_eng"
        case issuingCountryForDisplayUa = "issuing_country_for_display_ua"
        case genderForDisplay = "gender_for_display"
        case genderForDisplayUa = "gender_for_display_ua"
        case nationalityForDisplay = "nationality_for_display"
        case nationalityForDisplayUa = "nationality_for_display_ua"
        case residentAddressUa = "resident_address_ua"
        case birthPlaceUa = "birth_place_ua"
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
        issueDate = getValue(key: .issueDate)
        expiryDate = getValue(key: .expiryDate)
        issuingCountry = getValue(key: .issuingCountry)
        issuingAuthority = getValue(key: .issuingAuthority)
        documentNumber = getValue(key: .documentNumber)
        administrativeNumber = getValue(key: .administrativeNumber)
        nationality = getValue(key: .nationality)
        eyeColour = getValue(key: .eyeColour)
        hairColour = getValue(key: .hairColour)
        height = getValue(key: .height)
        weight = getValue(key: .weight)
        sex = getValue(key: .sex)
        residentAddress = getValue(key: .residentAddress)
        residentCountry = getValue(key: .residentCountry)
        residentCity = getValue(key: .residentCity)
        residentState = getValue(key: .residentState)
        residentPostalCode = getValue(key: .residentPostalCode)
        ageOver18 = getValue(key: .ageOver18)
        ageInYears = getValue(key: .ageInYears)
        ageBirthYear = getValue(key: .ageBirthYear)
        unDistinguishingSign = getValue(key: .unDistinguishingSign)
        issuingJurisdiction = getValue(key: .issuingJurisdiction)
        portraitCaptureDate = getValue(key: .portraitCaptureDate)
        familyNameNationalCharacter = getValue(key: .familyNameNationalCharacter)
        givenNameNationalCharacter = getValue(key: .givenNameNationalCharacter)
        biometricTemplateFace = getValue(key: .biometricTemplateFace)
        biometricTemplateSignatureSign = getValue(key: .biometricTemplateSignatureSign)
        
        middleNameUa = getValue(key: .middleNameUa)
        issuingCountryForDisplayEng = getValue(key: .issuingCountryForDisplayEng)
        issuingCountryForDisplayUa = getValue(key: .issuingCountryForDisplayUa)
        genderForDisplay = getValue(key: .genderForDisplay)
        genderForDisplayUa = getValue(key: .genderForDisplayUa)
        nationalityForDisplay = getValue(key: .nationalityForDisplay)
        nationalityForDisplayUa = getValue(key: .nationalityForDisplayUa)
        residentAddressUa = getValue(key: .residentAddressUa)
        birthPlaceUa = getValue(key: .birthPlaceUa)
        
        if let portraitValue: [UInt8] = getValue(key: .portrait) {
            portrait = Data(portraitValue).base64EncodedString()
        } else {
            portrait = nil
        }
        if let signatureValue: [UInt8] = getValue(key: .signatureUsualMark) {
            signatureUsualMark = Data(signatureValue).base64EncodedString()
        } else {
            signatureUsualMark = nil
        }
        
        if let isoMdl = docModel as? IsoMdlModel {
            drivingPrivileges = isoMdl.drivingPrivileges
        }
    }
}
