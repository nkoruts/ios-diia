//
//  CommonService+Defaults.swift
//

import Foundation
import UIKit
import DiiaNetwork

extension CommonService {

    var host: String {
        return EnvironmentVars.apiHost
    }

    var timeoutInterval: TimeInterval {
        return 30
    }
    
    var headers: [String: String]? {
        return ["Platform-Type": "iOS"]
    }
    
    var analyticsAdditionalParameters: String? {
        return nil
    }
}
