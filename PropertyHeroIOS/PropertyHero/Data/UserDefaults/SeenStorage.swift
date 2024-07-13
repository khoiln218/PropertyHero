//
//  SeenStorage.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/22/23.
//

import Foundation

struct SeenStorageDerep {
    let key = "product-seen-storage"
    private let userDefault = UserDefaults.standard
    let NOT_FOUND = -1
    
    func saveSeens(_ seenList: [Product]) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(seenList)
        let json = String(data: jsonData, encoding: .utf8)
        userDefault.set(json, forKey: key)
    }
    
    func getSeens() -> [Product] {
        let json = userDefault.string(forKey: key)
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode([Product].self, from: json?.data(using: .utf8) ?? Data()).reversed()
        } catch {
            return []
        }
    }
    
    func clearSeens() {
        userDefault.removeObject(forKey: key)
    }
    
    func getSeen() -> [Product] {
        let json = userDefault.string(forKey: key)
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode([Product].self, from: json?.data(using: .utf8) ?? Data())
        } catch {
            return []
        }
    }
    
    func addOrUpdateSeen(_ seenItem: Product) {
        var seenList = getSeen()
        let index = getIndex(seenList, productId: seenItem.Id)
        if index != NOT_FOUND {
            seenList.remove(at: index)
        }
        seenList.append(seenItem)
        saveSeens(Array(seenList.suffix(50)))
    }
    
    func getIndex(_ seenList: [Product], productId: Int) -> Int {
        for i in 0..<seenList.count {
            if seenList[i].Id == productId {
                return i
            }
        }
        return NOT_FOUND
    }
}
