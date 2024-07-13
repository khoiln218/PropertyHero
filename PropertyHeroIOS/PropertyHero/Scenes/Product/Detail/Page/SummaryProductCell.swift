//
//  SummaryProductCell.swift
//  CleanArchitecture
//
//  Created by KHOI LE on 5/28/21.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit
import Reusable

class SummaryProductCell: PageTableCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var gv: UILabel!
    @IBOutlet weak var gvView: UIView!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var floorView: UIView!
    @IBOutlet weak var deposit: UILabel!
    @IBOutlet weak var depositView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gvView.addBorders(edges: [.all], color: UIColor(hex: "#ECEFF1")!, width: 1)
        floorView.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        depositView.addBorders(edges: [.all], color: UIColor(hex: "#ECEFF1")!, width: 1)
    }
    
    func bindViewModel(_ viewModel: Product) {
        let priceText:NSMutableAttributedString = NSMutableAttributedString(string: viewModel.PropertyName + "  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(hex: "#607D8B")!])
        priceText.append(NSMutableAttributedString(string: String(viewModel.Price) + " ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(hex: "#2b50f6")!]))
        priceText.append(NSMutableAttributedString(string: "tr/thg", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor(hex: "#2b50f6")!]))
        price.attributedText = priceText
        title.text = viewModel.Title
        
        let gvText:NSMutableAttributedString = NSMutableAttributedString(string: String(viewModel.GrossFloorArea), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(hex: "#01A0B9")!])
        gvText.append(NSMutableAttributedString(string: " m\u{00B2}", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(hex: "#01A0B9")!]))
        gv.attributedText = gvText
        
        floor.text = viewModel.Floor > 0 ? String(viewModel.Floor) : "-"
        
        if viewModel.Deposit > 0 {
            let depositText:NSMutableAttributedString = NSMutableAttributedString(string: String(viewModel.Deposit), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(hex: "#01A0B9")!])
            depositText.append(NSMutableAttributedString(string: " tr/thg", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor(hex: "#01A0B9")!]))
            deposit.attributedText = depositText
        } else {
            deposit.attributedText = NSMutableAttributedString(string: "-", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor(hex: "#01A0B9")!])
        }
        layoutIfNeeded()
    }
}
