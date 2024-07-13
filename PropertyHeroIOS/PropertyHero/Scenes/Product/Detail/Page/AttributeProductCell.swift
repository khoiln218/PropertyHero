//
//  AttributeProductCell.swift
//  CleanArchitecture
//
//  Created by KHOI LE on 5/30/21.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit

class AttributeProductCell: PageTableCell {
    
    @IBOutlet weak var propertyType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var GFArea: UILabel!
    @IBOutlet weak var bedAndBath: UILabel!
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var elevator: UILabel!
    @IBOutlet weak var pet: UILabel!
    @IBOutlet weak var numberPerson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Product) {
        propertyType.text = viewModel.PropertyName
        
        var priceText = ""
        if viewModel.Deposit > 0 {
            priceText.append(String(viewModel.Deposit.clean) + "triệu / ")
        } else {
            priceText.append("- / ")
        }
        priceText.append(String(viewModel.Price.clean) + "triệu")
        price.text = String(priceText)
        
        var floorText = ""
        if viewModel.Floor > 0 {
            floorText = String(viewModel.Floor)
        } else {
            floorText = "-"
        }
        if viewModel.FloorCount > 0 {
            floorText.append(" / \(viewModel.FloorCount)")
        } else {
            floorText.append(" / -")
        }
        floor.text = floorText
        
        GFArea.text = String(viewModel.GrossFloorArea.clean) + "m\u{00B2}"
        
        var bedAndBathText = ""
        if viewModel.Bedroom > 0 {
            bedAndBathText = String(viewModel.Bedroom)
        } else {
            bedAndBathText = "-"
        }
        if viewModel.Bathroom > 0 {
            bedAndBathText.append(" / \(viewModel.Bathroom)")
        } else {
            bedAndBathText.append(" / -")
        }
        bedAndBath.text = bedAndBathText
        
        direction.text = viewModel.DirectionName
        elevator.text = viewModel.Elevator ? "Có" : "Không"
        pet.text = viewModel.Pets ? "Có" : "Không"
        numberPerson.text = viewModel.NumPerson > 0 ? String(viewModel.NumPerson) : "-"
    }
}
