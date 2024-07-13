//
//  ProductClusterCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/9/23.
//

import UIKit

class ProductClusterCell: PageCollectionCell {
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var empty: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindViewModel(_ viewModel: Product) {
        gradientLayer.removeFromSuperlayer()
        gradientLayer.frame = infoView.layer.bounds
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                                UIColor(red: 0, green: 0, blue: 0, alpha: 30).cgColor]
        self.infoView.layer.insertSublayer(gradientLayer, at: 0)
        self.infoView.clipsToBounds = true
        
        let price = String(viewModel.Price.clean)
        let unit = "tr/thg"
        self.priceLabel.text = price + unit
        
        self.addressLabel.text = viewModel.Address
        let imageUrl = viewModel.Images.components(separatedBy: ", ")[0]
        self.thumb.setImage(with: URL(string: imageUrl)) {[unowned self] (_,error,_,_) in
            if error == nil {
                empty.hidden()
                thumb.visible()
            } else {
                empty.visible()
                thumb.hidden()
            }
        }
        layoutIfNeeded()
    }
}
