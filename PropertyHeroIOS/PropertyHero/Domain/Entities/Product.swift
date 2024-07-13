//
//  Product.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/10/23.
//

import ObjectMapper
import Then

struct Feature: Codable {
    var Id = 0
    var Name = ""
    var Thumbnail = ""
}

extension Feature: Then { }

extension Feature: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        Id <- map["Id"]
        Name <- map["Name"]
        Thumbnail <- map["Thumbnail"]
    }
}

struct Furniture: Codable {
    var Id = 0
    var Name = ""
    var Thumbnail = ""
}

extension Furniture: Then { }

extension Furniture: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        Id <- map["Id"]
        Name <- map["Name"]
        Thumbnail <- map["Thumbnail"]
    }
}

struct Product: Codable {
    var Id = 0
    var Address = ""
    var Latitude = 0.0
    var Longitude = 0.0
    var CountryID = 0
    var ProvinceID = 0
    var DistrictID = 0
    var PropertyID = 0
    var BuildingID = 0
    var DirectionID = 0
    var Images = ""
    var Deposit = 0.0
    var Price = 0.0
    var Floor = 0
    var FloorCount = 0
    var SiteArea = 0.0
    var GrossFloorArea = 0.0
    var Bedroom = 0
    var Bathroom = 0
    var ServiceFee = 0.0
    var Elevator = false
    var Pets = false
    var NumPerson = 0
    var Title = ""
    var Content = ""
    var Note = ""
    var AccountID = 0
    var ContactName = ""
    var ContactPhone = ""
    var IsMeLikeThis = 0
    var Status = 0
    var NumView = 0
    var NumLike = 0
    var CreateDate = ""
    var PropertyName = ""
    var DirectionName = ""
    var BuildingName: String?
    var FeatureList: [Feature] = []
    var FurnitureList: [Furniture] = []
}

extension Product: Then { }

extension Product: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        Id <- map["Id"]
        Address <- map["Address"]
        Latitude <- map["Latitude"]
        Longitude <- map["Longitude"]
        CountryID <- map["CountryID"]
        ProvinceID <- map["ProvinceID"]
        DistrictID <- map["DistrictID"]
        PropertyID <- map["PropertyID"]
        BuildingID <- map["BuildingID"]
        DirectionID <- map["DirectionID"]
        Images <- map["Images"]
        Deposit <- map["Deposit"]
        Price <- map["Price"]
        Floor <- map["Floor"]
        FloorCount <- map["FloorCount"]
        SiteArea <- map["SiteArea"]
        GrossFloorArea <- map["GrossFloorArea"]
        Bedroom <- map["Bedroom"]
        Bathroom <- map["Bathroom"]
        ServiceFee <- map["ServiceFee"]
        Elevator <- map["Elevator"]
        Pets <- map["Pets"]
        NumPerson <- map["NumPerson"]
        Title <- map["Title"]
        Content <- map["Content"]
        Note <- map["Note"]
        AccountID <- map["AccountID"]
        ContactName <- map["ContactName"]
        ContactPhone <- map["ContactPhone"]
        IsMeLikeThis <- map["IsMeLikeThis"]
        Status <- map["Status"]
        NumView <- map["NumView"]
        NumLike <- map["NumLike"]
        CreateDate <- map["CreateDate"]
        PropertyName <- map["PropertyName"]
        DirectionName <- map["DirectionName"]
        BuildingName <- map["BuildingName"]
        FeatureList <- map["FeatureList"]
        FurnitureList <- map["FurnitureList"]
    }
}
