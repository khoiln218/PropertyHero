//
//  ProductCollectionCell.swift
//  CleanArchitecture
//
//  Created by KHOI LE on 5/31/21.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit

class FeatureCell: PageCollectionCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Feature) {
        image.setImage(with: URL(string: viewModel.Thumbnail))
        title.text = viewModel.Name
    }
}
