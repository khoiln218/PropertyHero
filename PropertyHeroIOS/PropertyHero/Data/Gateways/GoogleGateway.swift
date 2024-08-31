//
//  GoogleGateway.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/27/24.
//

import RxSwift
import MGArchitecture

protocol GoogleGatewayType {
    func translate(_ text: String) -> Observable<String>
}

struct GoogleGateway: GoogleGatewayType {
    
    func translate(_ text: String) -> Observable<String> {
        let lang = DefaultStorage().getLang()
        if lang == Lang.vi.rawValue {
            return Observable.just(text)
        } else {
            let input = API.GoogleTranslateInput(text)
            
            return API.shared.translate(input)
                .map { $0.translationData }
                .unwrap()
                .map { json in
                    if let result = json?.translations.first?.translatedText {
                        return result.replacingOccurrences(of: "<br/>", with: "\n")
                    } else {
                        return ""
                    }
                }
        }
    }
}
