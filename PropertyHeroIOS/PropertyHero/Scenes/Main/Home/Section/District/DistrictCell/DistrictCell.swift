//
//  DistrictCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 7/14/24.
//

import UIKit

class DistrictCell: PageCollectionCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumb: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: DistrictSuggest) {
        thumb.image = UIImage(named: viewModel.ImgRes)
        name.text = viewModel.Name
        layoutIfNeeded()
    }
}
