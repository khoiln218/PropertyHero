//
//  GatewaysAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/5/23.
//

import UIKit

protocol GatewaysAssembler {
    func resolve() -> CategoryGatewayType
    func resolve() -> ProductGatewayType
    func resolve() -> LocationGatewayType
    func resolve() -> LoginGatewayType
    func resolve() -> GoogleGatewayType
}

extension GatewaysAssembler where Self: DefaultAssembler {
    func resolve() -> CategoryGatewayType {
        return CategoryGateway()
    }
    
    func resolve() -> ProductGatewayType {
        return ProductGateway()
    }
    
    func resolve() -> LocationGatewayType {
        return LocationGateway()
    }
    
    func resolve() -> LoginGatewayType {
        return LoginGateway()
    }
    
    func resolve() -> GoogleGatewayType {
        return GoogleGateway()
    }
}
