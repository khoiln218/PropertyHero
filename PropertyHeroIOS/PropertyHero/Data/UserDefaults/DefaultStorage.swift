//
//  Storage.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/10/23.
//

import Foundation

struct DefaultStorage {
    private let latKey = "last-lat-storage"
    private let lngKey = "last-lng-storage"
    private let zoomKey = "last-zoom-storage"
    private let defaultProvinceKey = "default-province-storage"
    private let userDefault = UserDefaults.standard
    
    //Bến Thành Maker
    private let kCameraLatitude = 10.771513
    private let kCameraLongitude = 106.698387
    private let kMapZoom: Float = 15.0
    private let kProvince: Int = 2
    
    func setLastLatLng(_ lat: Double, lng: Double, zoom: Float) {
        userDefault.set(lat, forKey: latKey)
        userDefault.set(lng, forKey: lngKey)
        userDefault.set(zoom, forKey: zoomKey)
    }
    
    func getLastLat() -> Double {
        if userDefault.object(forKey: latKey) == nil { return kCameraLatitude }
        return userDefault.double(forKey: latKey)
    }
    
    func getLastLng() -> Double {
        if userDefault.object(forKey: lngKey) == nil { return kCameraLongitude }
        return userDefault.double(forKey: lngKey)
    }
    
    func getMapZoom() -> Float {
        if userDefault.object(forKey: zoomKey) == nil { return kMapZoom }
        return userDefault.float(forKey: zoomKey)
    }
    
    func setDefaultProvince(_ provinceId: Int) {
        userDefault.set(provinceId, forKey: defaultProvinceKey)
    }
    
    func getDefaultProvince() -> Int {
        if userDefault.object(forKey: defaultProvinceKey) == nil { return kProvince }
        return userDefault.integer(forKey: defaultProvinceKey)
    }
}
