//
//  MiddlePageCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 7/14/24.
//

import UIKit

class MiddlePageCell: PageCollectionCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var suggest: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView() {
        let colorF: UIColor = UIColor(hex: "#0077D5")!
        let colorB: UIColor = UIColor(hex: "#FEEDCC")!
        let black: UIColor = .black
        let font:UIFont = .italicSystemFont(ofSize: 16)
        let fontNormal:UIFont = .systemFont(ofSize: 16)
        let headerStr = "Nhận ngay thông tin về  bất động sản"
        let headerSub = " HOT! tại PHR "
        let attHeader: NSMutableAttributedString = NSMutableAttributedString(string: headerStr + headerSub)
        attHeader.setAttributes([.font: font.boldItalic, .foregroundColor: colorF, .backgroundColor : colorB], range: NSRange(location:headerStr.count , length: headerSub.count))
        
        attHeader.setAttributes([.font: fontNormal, .foregroundColor: black, .backgroundColor : colorB], range: NSRange(location:headerStr.count + 6 , length: 4))
        self.name.attributedText = attHeader
        
        let color: UIColor = UIColor(hex: "#486BF6")!
        let suggestStr = "PHR đề xuất theo khu vực"
        let suggestsub = " bằng AI"
        let attSuggest: NSMutableAttributedString = NSMutableAttributedString(string: suggestStr + suggestsub)
        attSuggest.setAttributes([.font: font.boldItalic, .foregroundColor: color], range: NSRange(location:suggestStr.count , length: suggestsub.count))
        self.suggest.attributedText = attSuggest
    }
}
