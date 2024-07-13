//
//  File.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/20/23.
//

import Dto
import ValidatedPropertyKit

struct ValidationResultViewModel {
    let validationResult: ValidationResult
    
    var backgroundColor: UIColor {
        switch validationResult {
        case .success:
            return .systemBackground
        case .failure:
            return UIColor.yellow.withAlphaComponent(0.2)
        }
    }
    
    var text: String {
        switch validationResult {
        case .success:
            return ""
        case .failure(let error):
            return error.description
        }
    }
}
