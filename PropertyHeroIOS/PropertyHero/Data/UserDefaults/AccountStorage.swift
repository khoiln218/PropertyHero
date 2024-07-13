//
//  AccountStorage.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import Foundation

struct AccountStorage {
    let key = "account-storage"
    let usernameKey = "username-key-storage"
    let loginKey = "account-login-storage"
    let passwordkey = "password-key-storage"
    private let userDefault = UserDefaults.standard
    
    func saveAccount(_ account: Account) {
        if account.AccountType == AccountType.hero.rawValue {
            saveUsername(account.UserName)
        } else {
            saveUsername(nil)
        }
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(account)
        let json = String(data: jsonData, encoding: .utf8)
        userDefault.set(json, forKey: key)
    }
    
    func getAccount() -> Account {
        let json = userDefault.string(forKey: key)
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode(Account.self, from: json?.data(using: .utf8) ?? Data())
        } catch {
            return Account()
        }
    }
    
    func saveUsername(_ username: String?) {
        userDefault.set(username, forKey: usernameKey)
    }
    
    func getUsername() -> String? {
        return userDefault.string(forKey: usernameKey)
    }
    
    func savePassword(_ password: String) {
        userDefault.set(password, forKey: passwordkey)
    }
    
    func getPassword() -> String {
        return userDefault.string(forKey: passwordkey) ?? ""
    }
    
    func clearPassword() {
        userDefault.removeObject(forKey: passwordkey)
    }
    
    func clearAccount() {
        userDefault.removeObject(forKey: key)
    }
    
    func setIsLogin() {
        userDefault.set(true, forKey: loginKey)
    }
    
    func isLogin() -> Bool {
        return userDefault.bool(forKey: loginKey)
    }
    
    func clearIsLogin() {
        userDefault.removeObject(forKey: loginKey)
    }
    
    func logout() {
        clearAccount()
        clearPassword()
        clearIsLogin()
    }
}

