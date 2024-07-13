//
//  UIImageView+SDWebImage.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/5/19.
//  Copyright © 2019 Sun Asterisk. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(with url: URL?, completion: SDExternalCompletionBlock? = nil) {
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "empty"), completed: completion)
    }
    
    func setAvatarImage(with url: URL?, completion: SDExternalCompletionBlock? = nil) {
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "default_avatar"), options: .refreshCached, completed: completion)
    }
}
