//
//  APIError.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/5/23.
//

import MGAPIService
import Foundation

struct APIResponseError: APIError {
    let statusCode: Int?
    let message: String
    
    var errorDescription: String? {
        return message
    }
}
