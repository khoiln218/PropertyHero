//
//  FooterProductCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/17/23.
//

import UIKit

class FooterProductCell: PageTableCell {

    @IBOutlet weak var desc: UILabel!
    
    var sendReport: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Product) {
        desc.text = viewModel.Content
        layoutIfNeeded()
    }
    
    
    @IBAction func report(_ sender: Any) {
        sendReport?()
    }
}
