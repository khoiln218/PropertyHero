//
//  HotCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 7/14/24.
//

import UIKit

class HotCell: PageCollectionCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var empty: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
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
        self.price.attributedText = attPrice
        
        self.name.text = viewModel.Title.withoutEmoji().trimmingCharacters(in: .whitespacesAndNewlines)
        self.address.text = viewModel.Address
        let imageUrl = viewModel.Images.components(separatedBy: ", ")[0]
        self.thumbnail.setImage(with: URL(string: imageUrl)) {[unowned self] (_,error,_,_) in
            if error == nil {
                empty.hidden()
                thumbnail.visible()
            } else {
                empty.visible()
                thumbnail.hidden()
            }
        }
        layoutIfNeeded()
    }
}
