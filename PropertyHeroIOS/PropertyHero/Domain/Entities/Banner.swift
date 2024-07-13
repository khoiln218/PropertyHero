//
//  Banner.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import ObjectMapper
import Then

struct Banner {
    var Id = 0
    var Thumbnail = ""
    var ImageDetails: Any?
    var Title: Any?
    var Description: Any?
    var Url: String?
    var CompanyName: String?
    var ContactPhone: Any?
}

extension Banner: Then { }

extension Banner: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        Id <- map["Id"]
        Thumbnail <- map["Thumbnail"]
        ImageDetails <- map["ImageDetails"]
        Title <- map["Title"]
        Description <- map["Description"]
        Url <- map["Url"]
        CompanyName <- map["CompanyName"]
        ContactPhone <- map["ContactPhone"]
    }
}
