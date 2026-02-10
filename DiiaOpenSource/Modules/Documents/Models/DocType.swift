import UIKit
import DiiaDocumentsCommonTypes

enum DocType: String, Codable, CaseIterable {
    // TODO: - REMOVE
    case driverLicense = "driver-license"

    init?(rawValue: String) {
        switch rawValue {
        case "driver-license", "driverLicense":
            self = .driverLicense
        default:
            return nil
        }
    }
    
    var name: String {
        return ""
    }

    var stackName: String {
        return name
    }

    static var allCardTypes: [DocType] {
        return DocType.allCases
    }

    var faqCategoryId: String {
        return ""
    }

    func storingKey() -> StoringKey? {
        return nil
    }
}

extension DocType: DocumentAttributesProtocol {
    var docCode: DocTypeCode { return self.rawValue }

    func warningModel() -> WarningModel? {
        return nil
    }

    var stackIconAppearance: DocumentStackIconAppearance {
        return .black
    }

    var isStaticDoc: Bool {
        return false
    }

    func isDocCodeSameAs(otherDocCode: DocTypeCode) -> Bool {
        DocType(rawValue: docCode) == DocType(rawValue: otherDocCode)
    }
}
