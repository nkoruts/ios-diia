//
//  CommunicationHelper.swift
//

import UIKit
import MessageUI
import StoreKit
import CoreLocation
import MapKit
import DiiaCommonTypes
import DiiaUIComponents

class CommunicationHelper {
    
    enum LinkType: String, Codable {
        case telegram = "Telegram"
        case viber = "Viber"
        case skype = "Skype"
        case facebook = "Facebook Messenger"
        case browser = "Веб-браузер"
        case monobank = "Monobank"
        case privatbank = "Privat24"
        case tel = "Телефон"
        case email = "Email клієнт"
        
        init(url: String) {
            switch url {
            case let str where (str.starts(with: "tg:") || str.starts(with: "https://t.me")):
                self = .telegram
            case let str where str.starts(with: "viber:"):
                self = .viber
            case let str where str.starts(with: "skype:"):
                self = .skype
            case let str where str.starts(with: "fb:"):
                self = .facebook
            case let str where str.starts(with: "app://com.ftband.mono"):
                self = .monobank
            case let str where str.starts(with: "privat24:"):
                self = .privatbank
            case let str where str.starts(with: "mailto:"):
                self = .email
            case let str where str.starts(with: "tel:"):
                self = .tel
            default:
                self = .browser
            }
        }
    }
    
    @discardableResult
    static func tryURL(urls: [String]) -> Bool {
        let application = UIApplication.shared
        for strUrl in urls {
            if let url = URL(string: strUrl), application.canOpenURL(url) {
                application.open(url)
                return true
            }
        }
        return false
    }
    
    private static func askApprove(link: LinkType, onApprove: @escaping Callback) {
        var linksApproved: [LinkType: Bool] = StoreHelper.instance.getValue(forKey: .didUserApproveLinks) ?? [:]
        if link == .tel || linksApproved[link] == true {
            onApprove()
            return
        }
        
        guard let topController = UIApplication.shared.visibleViewController else { return }
        
        let title = "Застосунок хоче відкрити " + link.rawValue
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Скасувати", style: .default)
        let okAction = UIAlertAction(title: "Відкрити", style: .default) { (_) in
            linksApproved[link] = true
            StoreHelper.instance.save(linksApproved, type: [LinkType: Bool].self, forKey: .didUserApproveLinks)
            onApprove()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        
        topController.present(alert, animated: true)
    }
    
    @discardableResult
    static func url(urlString: String?, linkType: LinkType? = nil) -> Bool {
        if let urlString = urlString, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            let link = linkType ?? LinkType(url: urlString)
            askApprove(link: link) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return true
        }
        
        return false
    }

}
