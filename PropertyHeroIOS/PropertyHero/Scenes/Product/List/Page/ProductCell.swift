//
//  ProductCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/22/23.
//

import UIKit

class ProductCell: PageTableCell {
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var empty: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Product) {
        let price = String(viewModel.Price.clean)
        let gv = String(viewModel.GrossFloorArea.clean)
        let unit = "triệu / \(gv)m\u{00B2}"
        let priceWithUnit = price + unit
        
        let font: UIFont = .boldSystemFont(ofSize: 18)
        let fontUnit: UIFont = .boldSystemFont(ofSize: 14)
        let colorUnit: UIColor = UIColor(hex: "#607D8B")!
        let attPrice: NSMutableAttributedString = NSMutableAttributedString(string: priceWithUnit, attributes: [.font:font])
        attPrice.setAttributes([.font: fontUnit], range: NSRange(location:priceWithUnit.count - 5 - gv.count, length: 5 + gv.count))
        attPrice.setAttributes([.foregroundColor: colorUnit], range: NSRange(location:priceWithUnit.count - 5 - gv.count, length: 5 + gv.count))
        self.priceLabel.attributedText = attPrice
        
        self.nameLabel.text = viewModel.Title
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
