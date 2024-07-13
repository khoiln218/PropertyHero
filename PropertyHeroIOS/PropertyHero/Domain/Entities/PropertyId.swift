//
//  PropertyId.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/27/23.
//

import ObjectMapper
import Then

struct PropertyId {
    var id = ""
    var value = ""
}

extension PropertyId: Then { }

extension PropertyId: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        value <- map["value"]
    }
}

struct Option {
    var peoperties: [PropertyId] = []
}

extension Option: Then { }

extension Option: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        peoperties <- map["options"]
    }
}
