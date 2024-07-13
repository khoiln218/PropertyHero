//
//  FooterProductCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/17/23.
//

import UIKit

class FooterProductCell: PageTableCell {

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var reportBtn: UIButton!
    
    var sendReport: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reportBtn.layer.cornerRadius = 8
        reportBtn.layer.borderColor = UIColor(hex: "#F44336")?.cgColor
        reportBtn.layer.borderWidth = 1
    }
    
    func bindViewModel(_ viewModel: Product) {
        desc.text = viewModel.Content
        layoutIfNeeded()
    }
    
    
    @IBAction func report(_ sender: Any) {
        sendReport?()
    }
}
