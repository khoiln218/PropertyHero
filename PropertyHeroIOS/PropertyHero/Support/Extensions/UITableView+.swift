//
//  UITableView+.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/12/23.
//

import UIKit
import RxCocoa

extension UITableView {
    var isEmpty: Binder<Bool> {
        return Binder(self) { tableView, isEmpty in
            if isEmpty {
                let frame = CGRect(x: 0,
                                   y: 0,
                                   width: tableView.frame.size.width,
                                   height: tableView.frame.size.height)
                let emptyView = EmptyDataView(frame: frame)
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
            }
        }
    }
}
