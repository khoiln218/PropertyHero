//
//  MarkerCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/12/23.
//

import UIKit

class MarkerCell: PageTableCell {
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var empty: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Marker, markerType: MarkerType) {
        self.nameLabel.text = viewModel.Name
        self.addressLabel.text = viewModel.Address
        self.addressLabel.isHidden = markerType == .attr
        self.thumb.setImage(with: URL(string: viewModel.Thumbnail)) {[unowned self] (_,error,_,_) in
            if error == nil {
                empty.hidden()
            } else {
                empty.visible()
            }
        }
    }
}
