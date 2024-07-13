//
//  Marker.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/12/23.
//

import ObjectMapper
import Then

struct Marker {
    var Id = 0
    var Name = ""
    var Address = ""
    var Latitude = 0.0
    var Longitude = 0.0
    var Thumbnail = ""
    var FloorCount = 0
    var distance = 0.0
}

extension Marker: Then { }

extension Marker: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        Id <- map["Id"]
        Name <- map["Name"]
        Address <- map["Address"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        Thumbnail <- map["Thumbnail"]
        FloorCount <- map["FloorCount"]
    }
}
