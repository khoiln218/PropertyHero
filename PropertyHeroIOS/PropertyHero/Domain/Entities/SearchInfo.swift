//
//  SearchInfo.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/10/23.
//

struct SearchInfo {
    var startLat: Double = 0.0
    var startLng: Double = 0.0
    var endLat: Double = 0.0
    var endLng: Double = 0.0
    var distance: Double = 0.0
    var propertyType: Int = PropertyType.all.rawValue
    var propertyID: Int = 0
    var minPrice: Double = 0.0
    var maxPrice: Double = 0.0
    var minArea: Double = 0.0
    var maxArea: Double = 0.0
    var bed: Int = 0
    var bath: Int = 0
    var status: Int = Constants.undefined.rawValue
    var pageNo = 0
}
