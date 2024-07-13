//
//  UIView+.swift
//  BaoDongThap
//
//  Created by KHOI LE on 10/23/22.
//

import UIKit

extension UIView {
    
    func hidden(gone: Bool = false) -> Void {
        if gone {
            self.constraints.filter{ $0.firstAttribute == .width && $0.relation == .equal && $0.secondAttribute == .notAnAttribute }.forEach( {$0.constant = 0 })
            self.constraints.filter{ $0.firstAttribute == .height && $0.relation == .equal && $0.secondAttribute == .notAnAttribute }.forEach( {$0.constant = 0 })
            self.layoutIfNeeded()
        }
        self.isHidden = true
    }
    
    func visible(width: CGFloat = 0, height: CGFloat = 0) -> Void {
        if width > 0 {
            self.constraints.filter{ $0.firstAttribute == .width && $0.relation == .equal && $0.secondAttribute == .notAnAttribute }.forEach( {$0.constant = width })
        }
        if height > 0 {
            self.constraints.filter{ $0.firstAttribute == .height && $0.relation == .equal && $0.secondAttribute == .notAnAttribute }.forEach( {$0.constant = height })
        }
        self.layoutIfNeeded()
        self.isHidden = false
    }
    
    func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {
        
        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            return borderView
        }
        
        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder()
            self.addSubview(topBorder)
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: width)
            ])
        }
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder()
            self.addSubview(leftBorder)
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder()
            self.addSubview(rightBorder)
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
            ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder()
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
            ])
        }
    }
}

extension UIView {
    func recursiveFindSubview(of name: String) -> UIView? {
        for view in subviews {
            if view.isKind(of: NSClassFromString(name)!) {
                return view
            }
        }
        for view in subviews {
            if let tempView = view.recursiveFindSubview(of: name) {
                return tempView
            }
        }
        return nil
    }
}
