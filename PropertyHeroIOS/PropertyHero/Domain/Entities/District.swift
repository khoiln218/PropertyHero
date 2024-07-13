//
//  District.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/14/23.
//

import ObjectMapper
import Then

struct District {
    var Latitude = 0.0
    var Longitude = 0.0
    var ProvinceID = 0
    var Id = 0
    var Name = ""
}

extension District: Then { }

extension District: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        ProvinceID <- map["ProvinceID"]
        Id <- map["Id"]
        Name <- map["Name"]
    }
}
