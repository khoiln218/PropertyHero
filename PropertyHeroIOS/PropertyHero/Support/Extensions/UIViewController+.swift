//
//  UIViewController+.swift
//  BaoDongThap
//
//  Created by KHOI LE on 9/20/22.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    func showError(message: String, completion: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "Error",
                                   message: message,
                                   preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    func showAutoCloseMessage(image: UIImage?,
                              title: String?,
                              message: String?,
                              interval: TimeInterval = 2,
                              completion: (() -> Void)? = nil) {
        if let image = image {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .customView
            hud.customView = UIImageView(image: image)
            hud.label.text = title
            hud.detailsLabel.text = message
            
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                MBProgressHUD.hide(for: self.view, animated: true)
                completion?()
            }
        } else {
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .alert)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                ac.dismiss(animated: true, completion: completion)
            }
            
            present(ac, animated: true, completion: nil)
        }
    }
    
    func removeBackButtonTitle() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        statusBarHeight = UIApplication.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func showCoomingSoon(_ container: UIView) {
        after(interval: 1.5, completion: {
            let frame = CGRect(x: 0,
                               y: 0,
                               width: container.frame.size.width,
                               height: container.frame.size.height)
            let coomingView = EmptyDataView(frame: frame)
            container.addSubview(coomingView)
        })
    }
}
