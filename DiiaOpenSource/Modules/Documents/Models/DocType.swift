import UIKit
import DiiaDocumentsCommonTypes

enum DocType: String, Codable, CaseIterable {
    // TODO: - REMOVE
    case pidDocument = "PID"
    case mdlDocument = "mDL"
    case corDocument = "COR"

    init?(rawValue: String) {
        switch rawValue {
        case "PID":
            self = .pidDocument
        case "mDL":
            self = .mdlDocument
        case "COR":
            self = .corDocument
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .pidDocument: R.Strings.pid_document_name.localized()
        case .mdlDocument: R.Strings.mdl_document_name.localized()
        case .corDocument: R.Strings.cor_document_name.localized()
        }
    }

    var stackName: String {
        return name
    }

    static var allCardTypes: [DocType] {
        return DocType.allCases
    }

    var faqCategoryId: String {
        switch self {
        case .pidDocument: "pid"
        case .mdlDocument: "mdl"
        case .corDocument: "cor"
        }
    }

    func storingKey() -> StoringKey? {
        switch self {
        case .pidDocument: .pidDocument
        case .mdlDocument: .mdlDocument
        case .corDocument: .corDocument
        }
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
