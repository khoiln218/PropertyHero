//
//  Translate.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/27/24.
//

import ObjectMapper
import Then

// Model cho từng bản dịch
struct Translation {
    var translatedText = ""
    var detectedSourceLanguage = ""
}

extension Translation: Then { }

extension Translation: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        translatedText <- map["translatedText"]
        detectedSourceLanguage <- map["detectedSourceLanguage"]
    }
}

// Model cho phần "data"
struct TranslationData {
    var translations: [Translation] = []
}

extension TranslationData: Then { }

extension TranslationData: Mappable {
    init?(map: Map) {
        self.init()
    }

    mutating func mapping(map: Map) {
        translations <- map["translations"]
    }
}
