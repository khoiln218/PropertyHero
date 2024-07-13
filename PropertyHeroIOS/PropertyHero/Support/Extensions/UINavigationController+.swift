//
//  UINavigation+.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit

extension UINavigationController {
    func showViewControllerInMain(_ tagert: MainViewController, tab: TabMenu) {
        for subview in tagert.viewpager.subviews {
            subview.layer.zPosition = 1
            subview.isUserInteractionEnabled = false
        }
        tagert.viewpager.subviews[tab.rawValue].layer.zPosition = 99
        tagert.viewpager.subviews[tab.rawValue].isUserInteractionEnabled = true
    }
    
    func addFragmentToMain(_ tagert: MainViewController, vc: UIViewController, tab: TabMenu) {
        print("addFragmentToMain", tab)
        let container = vc.view!
        tagert.addChild(vc)
        vc.didMove(toParent: tagert)
        tagert.viewpager.insertSubview(vc.view, at: tab.rawValue)
        DispatchQueue.main.async {
            container.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                container.leadingAnchor.constraint(equalTo: tagert.viewpager.leadingAnchor),
                container.topAnchor.constraint(equalTo: tagert.viewpager.topAnchor),
                container.bottomAnchor.constraint(equalTo: tagert.viewpager.bottomAnchor),
                container.trailingAnchor.constraint(equalTo: tagert.viewpager.trailingAnchor)
            ])
        }
    }
}

extension UINavigationController {
    func showViewControllerInSearch(_ tagert: SearchViewController, tab: TabSearch) {
        for subview in tagert.viewpager.subviews {
            subview.layer.zPosition = 1
            subview.isUserInteractionEnabled = false
        }
        tagert.viewpager.subviews[tab.rawValue].layer.zPosition = 99
        tagert.viewpager.subviews[tab.rawValue].isUserInteractionEnabled = true
    }
    
    func addFragmentToSearch(_ tagert: SearchViewController, vc: UIViewController, tab: TabSearch) {
        print("addFragmentToSearch", tab)
        let container = vc.view!
        tagert.addChild(vc)
        vc.didMove(toParent: tagert)
        tagert.viewpager.insertSubview(container, at: tab.rawValue)
        DispatchQueue.main.async {
            container.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                container.leadingAnchor.constraint(equalTo: tagert.viewpager.leadingAnchor),
                container.topAnchor.constraint(equalTo: tagert.viewpager.topAnchor),
                container.bottomAnchor.constraint(equalTo: tagert.viewpager.bottomAnchor),
                container.trailingAnchor.constraint(equalTo: tagert.viewpager.trailingAnchor)
            ])
        }
    }
}

extension UINavigationController {
    func showViewControllerInCollection(_ tagert: CollectionViewController, tab: TabCollection) {
        for subview in tagert.viewpager.subviews {
            subview.layer.zPosition = 1
            subview.isUserInteractionEnabled = false
        }
        tagert.viewpager.subviews[tab.rawValue].layer.zPosition = 99
        tagert.viewpager.subviews[tab.rawValue].isUserInteractionEnabled = true
    }
    
    func addFragmentToCollection(_ tagert: CollectionViewController, vc: UIViewController, tab: TabCollection) {
        print("addFragmentToCollection", tab)
        let container = vc.view!
        tagert.addChild(vc)
        vc.didMove(toParent: tagert)
        tagert.viewpager.insertSubview(container, at: tab.rawValue)
        DispatchQueue.main.async {
            container.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                container.leadingAnchor.constraint(equalTo: tagert.viewpager.leadingAnchor),
                container.topAnchor.constraint(equalTo: tagert.viewpager.topAnchor),
                container.bottomAnchor.constraint(equalTo: tagert.viewpager.bottomAnchor),
                container.trailingAnchor.constraint(equalTo: tagert.viewpager.trailingAnchor)
            ])
        }
    }
}
