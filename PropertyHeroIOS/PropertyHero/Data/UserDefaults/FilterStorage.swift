//
//  FilterStorage.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/27/23.
//

import Foundation

struct FilterStorage {
    let KEY_PROPERTY = "KEY_PROPERTY"
    let KEY_MIN_PRICE = "KEY_MIN_PRICE"
    let KEY_MAX_PRICE = "KEY_MAX_PRICE"
    let KEY_MIN_AREA = "KEY_MIN_AREA"
    let KEY_MAX_AREA = "KEY_MAX_AREA"
    let KEY_BED = "KEY_BED"
    let KEY_BATH = "KEY_BATH"
    
    private let userDefault = UserDefaults.standard
    
    func addFilterSet(_ searchInfo: SearchInfo) {
        userDefault.set(searchInfo.propertyID, forKey: KEY_PROPERTY)
        userDefault.set(searchInfo.minPrice, forKey: KEY_MIN_PRICE)
        userDefault.set(searchInfo.maxPrice, forKey: KEY_MAX_PRICE)
        userDefault.set(searchInfo.minArea, forKey: KEY_MIN_AREA)
        userDefault.set(searchInfo.maxArea, forKey: KEY_MAX_AREA)
        userDefault.set(searchInfo.bed, forKey: KEY_BED)
        userDefault.set(searchInfo.bath, forKey: KEY_BATH)
    }
    
    func getFilterSet() -> SearchInfo {
        let propertyId = getIntValue(KEY_PROPERTY)
        let minPrice = getDoubleValue(KEY_MIN_PRICE)
        let maxPrice = getDoubleValue(KEY_MAX_PRICE)
        let minArea = getDoubleValue(KEY_MIN_AREA)
        let maxArea = getDoubleValue(KEY_MAX_AREA)
        let bed = getIntValue(KEY_BED)
        let bath = getIntValue(KEY_BATH)
        return SearchInfo(propertyID: Int(propertyId), minPrice: minPrice, maxPrice: maxPrice, minArea: minArea, maxArea: maxArea, bed: Int(bed), bath: Int(bath))
    }
    
    func defaultFilterSet() -> SearchInfo {
        let defaultFilter = SearchInfo()
        userDefault.set(defaultFilter.propertyID, forKey: KEY_PROPERTY)
        userDefault.set(defaultFilter.minPrice, forKey: KEY_MIN_PRICE)
        userDefault.set(defaultFilter.maxPrice, forKey: KEY_MAX_PRICE)
        userDefault.set(defaultFilter.minArea, forKey: KEY_MIN_AREA)
        userDefault.set(defaultFilter.maxArea, forKey: KEY_MAX_AREA)
        userDefault.set(defaultFilter.bed, forKey: KEY_BED)
        userDefault.set(defaultFilter.bath, forKey: KEY_BATH)
        return defaultFilter
    }
    
    func getDoubleValue(_ key: String) -> Double {
        if userDefault.object(forKey: key) == nil { return 0.0 }
        return userDefault.double(forKey: key)
    }
    
    func getIntValue(_ key: String) -> Int {
        if userDefault.object(forKey: key) == nil {
            if key == KEY_PROPERTY {
                return PropertyType.all.rawValue
            }
            return 0
        }
        return userDefault.integer(forKey: key)
    }
}
