//
//  DocClaimsDecodable+Ext.swift
//  Diia
//
//  Created by Nikita Koruts on 06.11.2024.
//  Copyright © 2024 Diia. All rights reserved.
//

import Foundation
import MdocDataModel18013

extension DocClaimsDecodable {
    static func getCborItemValue<T>(_ nameSpaceItems: [NameSpace: [IssuerSignedItem]], string name: String) -> T? {
        for (_, v) in nameSpaceItems {
            if let item = v.first(where: { name == $0.elementIdentifier }) {
                return item.getTypedValue()
            }
        }
        return nil
    }
}
