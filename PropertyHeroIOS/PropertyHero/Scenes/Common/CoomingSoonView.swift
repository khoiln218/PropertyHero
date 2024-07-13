//
//  CoomingSoonView.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit
import Reusable

final class CoomingSoonView: UIView, NibOwnerLoadable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibContent()
    }
}
