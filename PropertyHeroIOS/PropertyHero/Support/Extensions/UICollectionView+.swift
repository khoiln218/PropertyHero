//
//  UICollectionView+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 9/5/18.
//  Copyright © 2018 Sun Asterisk. All rights reserved.
//

import UIKit
import RxCocoa

extension UICollectionView {
    var isEmpty: Binder<Bool> {
        return Binder(self) { collectionView, isEmpty in
            if isEmpty {
                let frame = CGRect(x: 0,
                                   y: 0,
                                   width: collectionView.frame.size.width,
                                   height: collectionView.frame.size.height)
                let emptyView = EmptyDataView(frame: frame)
                collectionView.backgroundView = emptyView
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
    
    func scrollToNearestVisibleCollectionViewCell(_ position: Int) {
        let startIndex = Int(self.contentOffset.x / self.visibleCells[0].bounds.size.width)
        let delta = (position + 1) <= startIndex + self.visibleCells.count ? -1 : 1
        var mid = position + delta
        if mid < 0 { mid = 0 }
        self.scrollToItem(at: IndexPath(row: mid, section: 0), at: .left, animated: true)
    }
}
