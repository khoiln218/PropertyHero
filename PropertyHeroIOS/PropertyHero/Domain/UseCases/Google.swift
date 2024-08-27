//
//  Google.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/27/24.
//

import RxSwift
import MGArchitecture

protocol Google {
    var googleGateway: GoogleGatewayType { get }
}

extension Google {
    func translate(_ text: String) -> Observable<String> {
        return googleGateway.translate(text)
    }
}
