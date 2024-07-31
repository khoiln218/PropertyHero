//
//  Dimension.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/27/22.
//

import Foundation
import UIKit

struct Dimension {
    static var SCREEN_WIDTH: CGFloat {
        if let window = UIApplication.keyWindow {
            return UIScreen.main.bounds.width - window.safeAreaInsets.left - window.safeAreaInsets.right
        }
        return UIScreen.main.bounds.width
    }
    
    static var SCREEN_HEIGHT: CGFloat {
        if let window = UIApplication.keyWindow {
            return UIScreen.main.bounds.height - window.safeAreaInsets.top - window.safeAreaInsets.bottom
        }
        return UIScreen.main.bounds.height
    }
    
    static var HEADER_HEIGHT: CGFloat {
        let width = Dimension.SCREEN_WIDTH
        return width / 2 + 56 + 124 + 32
    }
    
    static var HOT_WIDTH: CGFloat {
        return (Dimension.SCREEN_WIDTH - 32) / 2
    }
    
    static var HOT_HEIGHT: CGFloat {
        let width = Dimension.HOT_WIDTH
        return width + 24 + 82
    }
    
    static var AREA_ITEM_WIDTH: CGFloat {
        return (Dimension.SCREEN_WIDTH - 8) / 3
    }
    
    static var AREA_ITEM_HEIGHT: CGFloat {
        let width = (Dimension.SCREEN_WIDTH - 8) / 3
        return width / 2 + 34
    }
}
