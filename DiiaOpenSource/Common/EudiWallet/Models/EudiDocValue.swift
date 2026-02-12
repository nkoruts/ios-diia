//
//  EudiDocValue.swift
//  Diia
//
//  Created by Nikita Koruts on 13.02.2025.
//  Copyright © 2025 Diia. All rights reserved.
//

import Foundation

typealias EudiDocValues = [String: [String: EudiDocItemValue]]

public struct EudiDocItemValue {
    let namespace: String
    let docType: String
    let isOptional: Bool
    let displayName: EudiDocItemDisplayName
    let valueName: String
}

public struct EudiDocItemDisplayName {
    let en: String
    let ua: String?
}
