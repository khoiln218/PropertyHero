//
//  API+Google.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/27/24.
//

import ObjectMapper
import RxSwift
import MGAPIService

extension API {
    func translate(_ input: GoogleTranslateInput) -> Observable<GoogleTranslateOutput> {
        return request(input)
    }
}

extension API {
    final class GoogleTranslateInput: APIInput {
        init(_ text: String) {
            let newText = text.replacingOccurrences(of: "\n", with: "<br/>")
            let parameters: JSONDictionary = [
                        "q": newText,
                        "target": "en",
                        "source": "vi",
                        "format": "html",
                        "key": "AIzaSyCPgTYYK5JGblBzus6SIlXmg-26etzxD20"
                    ]
            super.init(urlString: API.Urls.googleTranslate,
                       parameters: parameters,
                       method: .get,
                       requireAccessToken: true)
        }
    }
    
    final class GoogleTranslateOutput: APIOutput {
        private(set) var translationData: TranslationData?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            translationData <- map["data"]
        }
    }
}

