//
//  LayoutOptions.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 16/12/2020.
//  Copyright © 2020 Sun Asterisk. All rights reserved.
//

import UIKit

struct LayoutOptions {
    var itemSpacing: CGFloat
    var lineSpacing: CGFloat
    var itemsPerRow: Int
    var sectionInsets: UIEdgeInsets
    var itemHeight: CGFloat
    var itemWidth: CGFloat
}

extension LayoutOptions {
    var itemAutoWidth: CGFloat {
        let paddingSpace = sectionInsets.left
            + sectionInsets.right
            + CGFloat(itemsPerRow - 1) * itemSpacing
        let availableWidth = Dimension.SCREEN_WIDTH - paddingSpace
        return availableWidth / CGFloat(itemsPerRow)
    }
    
    var itemSize: CGSize {
        return itemWidth != 0
            ? CGSize(width: itemWidth, height: itemHeight)
            : CGSize(width: itemAutoWidth, height: itemHeight)
    }
}
