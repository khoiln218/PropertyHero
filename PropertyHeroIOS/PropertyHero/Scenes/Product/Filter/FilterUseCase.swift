//
//  FilterUseCase.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/25/23.
//

import RxSwift
import Dto
import ValidatedPropertyKit

protocol FilterUseCaseType {
    func getListProperty() -> Observable<[PropertyId]>
    func verifyPrice(_ minPrice: String, maxPrice: String) -> ValidationResult
    func verifyArea(_ minArea: String, maxArea: String) -> ValidationResult
}

struct FilterUseCase: FilterUseCaseType, GetCategory {
    var categoryGateway: CategoryGatewayType
    
    func getListProperty() -> Observable<[PropertyId]> {
        categoryGateway.getListProperty()
            .map { properties in
                var newProperty = properties
                newProperty.insert(PropertyId(id: "1000", value: "Tất cả"), at: 0)
                return newProperty
            }
    }
    
    func verifyPrice(_ minPrice: String, maxPrice: String) -> ValidationResult {
        let min = Double(minPrice) ?? 0
        let max = Double(maxPrice) ?? 0
        if max >= min {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Mức giá không hợp lệ vui lòng nhập lại"))
        }
    }
    
    func verifyArea(_ minArea: String, maxArea: String) -> ValidationResult {
        let min = Double(minArea) ?? 0
        let max = Double(maxArea) ?? 0
        if max >= min {
            return .success(())
        } else {
            return .failure(ValidationError(message: "Diện tích không hợp lệ vui lòng nhập lại"))
        }
    }
}
