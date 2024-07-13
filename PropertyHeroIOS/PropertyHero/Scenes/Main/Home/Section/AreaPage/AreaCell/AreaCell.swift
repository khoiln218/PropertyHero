//
//  AreaCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit

class AreaCell: PageCollectionCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Marker) {
        self.thumbnail.setImage(with: URL(string: viewModel.Thumbnail))
        self.name.text = viewModel.Name
    }
}
