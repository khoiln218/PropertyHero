//
//  FavoriteStorage.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/22/23.
//

import Foundation

struct FavoriteStorageDerep {
    let key = "product-favorite-storage"
    private let userDefault = UserDefaults.standard
    let NOT_FOUND = -1
    
    func saveFavorites(_ favoriteList: [Product]) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(favoriteList)
        let json = String(data: jsonData, encoding: .utf8)
        userDefault.set(json, forKey: key)
    }
    
    func getFavorites() -> [Product] {
        let json = userDefault.string(forKey: key)
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode([Product].self, from: json?.data(using: .utf8) ?? Data()).reversed()
        } catch {
            return []
        }
    }
    
    func clearFavorites() {
        userDefault.removeObject(forKey: key)
    }
    
    func getFavorite() -> [Product] {
        let json = userDefault.string(forKey: key)
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode([Product].self, from: json?.data(using: .utf8) ?? Data())
        } catch {
            return []
        }
    }
    
    func insertFavorite(_ product: Product) {
        var favoriteList = getFavorite()
        favoriteList.append(product)
        saveFavorites(Array(favoriteList.suffix(50)))
    }
    
    func deleteFavorite(_ product: Product) {
        var favoriteList = getFavorite()
        let index = getIndex(favoriteList, productId: product.Id)
        if index != NOT_FOUND {
            favoriteList.remove(at: index)
            saveFavorites(favoriteList)
        }
    }
    
    func updateFavorite(_ product: Product) {
        var favoriteList = getFavorite()
        let index = getIndex(favoriteList, productId: product.Id)
        if index != NOT_FOUND {
            favoriteList[index] = product
            saveFavorites(favoriteList)
        }
    }
    
    func isFavorite(_ productId: Int) -> Bool {
        let favoriteList = getFavorite()
        let index = getIndex(favoriteList, productId: productId)
        return index != NOT_FOUND
    }
    
    func getIndex(_ favoriteList: [Product], productId: Int) -> Int {
        for i in 0..<favoriteList.count {
            if favoriteList[i].Id == productId {
                return i
            }
        }
        return NOT_FOUND
    }
}
