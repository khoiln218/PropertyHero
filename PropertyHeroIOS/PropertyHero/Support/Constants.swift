//
//  Utils.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import Foundation

enum GenderName: String {
    case female = "Nữ"
    case male = "Nam"
    case other = "Khác"
}

enum Gender: Int {
    case female = 0
    case male = 1
    case other = 2
}

enum AccountStatus: Int {
    case accLocked = 200
    case accDeletion = 250
}

enum AccountType: Int {
    case hero = 0
    case facebook = 1
    case google = 2
    case apple = 3
}

enum MarkerType: Int {
    case all = 254
    case building = 0
    case attr = 1
}

enum Constants: Int {
    case undefined = 254
}

enum TabCollection: Int {
    case favorite = 0
    case view = 1
}

enum TabSearch: Int {
    case marker = 0
    case location = 1
}

enum TabMenu: Int {
    case more = 0
    case notification = 1
    case collection = 2
    case search = 3
    case home = 4
}

enum PropertyType: Int {
    case all = 1000
    case house = 1020
    case apartment = 1010
    case land = 1040
    case room = 1050
    case office = 1030
}

enum CountryId: Int {
    case vietnam = 1
}

enum OptionChoice {
    case all
    case apartment
    case room
}

enum SectionType {
    case banner
    case hot
    case middle
    case hcm
    case hn
    case findByArea
}

