//
//  Relocation.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/23/23.
//

import ObjectMapper
import Then

struct Relocation {
    var Id = 0
    var Thumbnail = ""
    var ImageDetails = ""
    var Title: Any?
    var Description: Any?
    var Url = ""
    var CompanyName: String?
    var ContactPhone = ""
}

extension Relocation: Then { }

extension Relocation: Mappable {
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
