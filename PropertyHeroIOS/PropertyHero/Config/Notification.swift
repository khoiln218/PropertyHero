//
//  Notification.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import UIKit

extension Notification.Name {
    static let loginSuccess = Notification.Name(rawValue: "authentication.login.success")
    static let logout = Notification.Name(rawValue: "authentication.logout")
    static let productViewChanged = Notification.Name(rawValue: "collection.productViewChanged")
    static let favoriteChanged = Notification.Name(rawValue: "collection.favoriteChanged")
    static let collectionChanged = Notification.Name(rawValue: "collection.collectionChanged")
    static let avatarChanged = Notification.Name(rawValue: "account.avatarChanged")
    static let infoChanged = Notification.Name(rawValue: "account.infoChanged")
    static let settingChanged = Notification.Name(rawValue: "account.settingChanged")
}
