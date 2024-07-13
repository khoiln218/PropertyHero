//
//  Province.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/12/23.
//

import ObjectMapper
import Then

struct Province {
    var PostalCode = ""
    var CountryID = 0
    var Id = 0
    var Name = ""
}

extension Province: Then { }

extension Province: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        PostalCode <- map["PostalCode"]
        CountryID <- map["CountryID"]
        Id <- map["Id"]
        Name <- map["Name"]
    }
}
