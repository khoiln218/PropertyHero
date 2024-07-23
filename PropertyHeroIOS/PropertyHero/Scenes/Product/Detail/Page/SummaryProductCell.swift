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
    @IBOutlet weak var gvBg: UIView!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var floorView: UIView!
    @IBOutlet weak var floorBg: UIView!
    @IBOutlet weak var deposit: UILabel!
    @IBOutlet weak var depositView: UIView!
    @IBOutlet weak var depositBg: UIView!
    @IBOutlet weak var idView: UIView!
    @IBOutlet weak var labelId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        idView.layer.borderWidth = 1.0
        idView.layer.borderColor = UIColor(hex: "#486BF6")?.cgColor
        idView.layer.cornerRadius = 5.0
        idView.clipsToBounds = true
        
        gvBg.layer.borderWidth = 1.0
        gvBg.layer.borderColor = UIColor(hex: "#E1E1E1")?.cgColor
        gvBg.layer.cornerRadius = 5.0
        gvBg.clipsToBounds = true
        
        floorBg.layer.borderWidth = 1.0
        floorBg.layer.borderColor = UIColor(hex: "#E1E1E1")?.cgColor
        floorBg.layer.cornerRadius = 10.0
        floorBg.clipsToBounds = true
        
        depositBg.layer.borderWidth = 1.0
        depositBg.layer.borderColor = UIColor(hex: "#E1E1E1")?.cgColor
        depositBg.layer.cornerRadius = 10.0
        depositBg.clipsToBounds = true
    }
    
    func bindViewModel(_ viewModel: Product) {
        labelId.text = "Mã tin: \(viewModel.Id)"
        
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
