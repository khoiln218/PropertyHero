//
//  Favorite.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/4/23.
//

import ObjectMapper
import Then

struct Favorite {
    var ProductID = 0
    var AccountID = 0
    var Title = ""
    var Price = 0.0
    var GrossFloorArea = 0.0
    var Avatar = ""
    var Address = ""
    var Status = 0
    var CreateDate = ""
    var ModifiedDate = ""
}

extension Favorite: Then { }

extension Favorite: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        ProductID <- map["ProductID"]
        AccountID <- map["AccountID"]
        Title <- map["Title"]
        Price <- map["Price"]
        GrossFloorArea <- map["GrossFloorArea"]
        Avatar <- map["Avatar"]
        Address <- map["Address"]
        Status <- map["Status"]
        CreateDate <- map["CreateDate"]
        ModifiedDate <- map["ModifiedDate"]
    }
}
