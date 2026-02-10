import UIKit
import Alamofire

struct AppConstants {
    
    static let defaultPinCodeLength = 4
    
    struct Notifications {
        static let documentsWasReordered = Notification.Name(rawValue: "kNDocumentsWasReordered")
    }
    
    struct Colors {
        static let clear = "#0000000"
        static let black = "#000000"
        static let white = "#FFFFFF"
        static let emptyDocumentsBackground = "#C5D9E9"
        static let documentVerifyLoadingBackground = "#676F76"
    }
}
