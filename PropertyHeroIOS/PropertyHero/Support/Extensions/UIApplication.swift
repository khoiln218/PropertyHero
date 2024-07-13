//
//  UIApplication.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/23/22.
//

import UIKit

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245
            
            let keyWindow = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0.0
                let statusBarView = UIView()
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999
                
                keyWindow?.addSubview(statusBarView)
                
                statusBarView.translatesAutoresizingMaskIntoConstraints = false
                statusBarView.heightAnchor
                    .constraint(equalToConstant: height).isActive = true
                statusBarView.widthAnchor
                    .constraint(equalTo: keyWindow!.widthAnchor, multiplier: 1.0).isActive = true
                statusBarView.topAnchor
                    .constraint(equalTo: keyWindow!.topAnchor).isActive = true
                statusBarView.centerXAnchor
                    .constraint(equalTo: keyWindow!.centerXAnchor).isActive = true
                
                return statusBarView
            }
            
        } else {
            
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
    
    class var topViewController: UIViewController? { return getTopViewController() }
    static let keyWindow = UIApplication
        .shared
        .connectedScenes
        .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
        .last { $0.isKeyWindow }
    private class func getTopViewController(base: UIViewController? = keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }
    
    static func share(_ url: String) {
        if let name = URL(string: url), !name.absoluteString.isEmpty {
            let objectsToShare = [name]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                popoverController.sourceView = UIApplication.topViewController?.view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
            UIApplication.topViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                application.open(URL(string: url)!)
                return
            }
        }
    }
}

