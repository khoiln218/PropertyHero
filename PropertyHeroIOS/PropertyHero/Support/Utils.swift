//
//  Utils.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/22/22.
//

import Foundation

func after(interval: TimeInterval, completion: (() -> Void)?) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
        completion?()
    }
}

func getDeviceId() -> String {
    let deviceId = retrive(for: "deviceId")
    if let deviceId = deviceId {
        return deviceId
    }
    
    let uuid = UUID().uuidString
    save(uuid, for: "deviceId")
    return uuid
}

func save(_ key: String, for value: String) {
    let key = key.data(using: String.Encoding.utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: value,
                                kSecValueData as String: key]
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else { return print("save error") }
}

func retrive(for value: String) -> String? {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: value,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnData as String: kCFBooleanTrue as Any]
    
    
    var retrivedData: AnyObject? = nil
    let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
    
    
    guard let data = retrivedData as? Data else {return nil}
    return String(data: data, encoding: String.Encoding.utf8)
}
