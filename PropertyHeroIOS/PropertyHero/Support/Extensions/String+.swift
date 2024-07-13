//
//  String+.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/23/23.
//

import Foundation

extension String {
    func withoutEmoji() -> String {
        unicodeScalars
            .filter { (!$0.properties.isEmojiPresentation && !$0.properties.isEmoji) || $0.properties.numericType == .decimal }
            .reduce(into: "") { $0 += String($1) }
    }
}
