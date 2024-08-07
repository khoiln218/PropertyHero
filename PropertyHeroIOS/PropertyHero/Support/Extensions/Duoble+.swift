//
//  Float.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/16/23.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
