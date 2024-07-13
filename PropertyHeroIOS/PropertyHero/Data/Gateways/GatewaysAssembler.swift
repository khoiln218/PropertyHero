//
//  GatewaysAssembler.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/5/23.
//

import UIKit

protocol GatewaysAssembler {
    func resolve() -> CategoryGatewayType
    func resolve() -> ProductGateway
    func resolve() -> LocationGateway
    func resolve() -> LoginGatewayType
}

extension GatewaysAssembler where Self: DefaultAssembler {
    func resolve() -> CategoryGatewayType {
        return CategoryGateway()
    }
    
    func resolve() -> ProductGateway {
        return ProductGateway()
    }
    
    func resolve() -> LocationGateway {
        return LocationGateway()
    }
    
    func resolve() -> LoginGatewayType {
        return LoginGateway()
    }
}
