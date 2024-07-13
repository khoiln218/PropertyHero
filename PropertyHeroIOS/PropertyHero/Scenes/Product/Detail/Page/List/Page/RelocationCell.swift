//
//  RelocationCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/15/23.
//

import UIKit

class RelocationCell: PageCollectionCell {
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Relocation) {
        thumbnail.setImage(with: URL(string: viewModel.Thumbnail))
        layoutIfNeeded()
    }
}
