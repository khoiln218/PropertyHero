//
//  Account.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import ObjectMapper
import Then

struct Account: Codable {
    var Id = 0
    var UserName = ""
    var FullName = ""
    var Gender = 0
    var BirthDate = ""
    var PhoneNumber = ""
    var Email = ""
    var Address = ""
    var CountryID = 0
    var ProvinceID = 0
    var DistrictID = 0
    var Avatar = ""
    var IDCode = ""
    var IssuedDate = ""
    var IssuedPlace = ""
    var AccountRole = 0
    var AccountType = 0
    var Status = 0
}

extension Account: Then { }

extension Account: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        Id <- map["Id"]
        UserName <- map["UserName"]
        FullName <- map["FullName"]
        Gender <- map["Gender"]
        BirthDate <- map["BirthDate"]
        PhoneNumber <- map["PhoneNumber"]
        Email <- map["Email"]
        Address <- map["Address"]
        CountryID <- map["CountryID"]
        ProvinceID <- map["ProvinceID"]
        DistrictID <- map["DistrictID"]
        Avatar <- map["Avatar"]
        IDCode <- map["IDCode"]
        IssuedDate <- map["IssuedDate"]
        IssuedPlace <- map["IssuedPlace"]
        AccountRole <- map["AccountRole"]
        AccountType <- map["AccountType"]
        Status <- map["Status"]
    }
}
