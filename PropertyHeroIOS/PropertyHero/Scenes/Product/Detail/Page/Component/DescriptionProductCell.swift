//
//  DescriptionProductCell.swift
//  CleanArchitecture
//
//  Created by KHOI LE on 5/30/21.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit
import WebKit

class DescriptionProductCell: PageDetailCell {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var viewMoreButton: UIButton!
    
    var descriptionViewMore: (() -> Void)?
    
    let wkWebView = WKWebView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        wkWebView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.5)
        container.insertSubview(wkWebView, at: 0)
        wkWebView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        wkWebView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.isScrollEnabled = false
        
        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(
            string: "detail_view_all".localized(),
            attributes: attributes
        )
        viewMoreButton.setAttributedTitle(attributeString, for: .normal)
        
    }
    
    @IBAction func viewMore(_ sender: Any) {
        descriptionViewMore!()
    }
    
    func bindViewModel(_ viewModel: Product) {
        let htmlString = createHtml(viewModel.bodyHtml)
        wkWebView.loadHTMLString(htmlString, baseURL: nil)
        wkWebView.contentMode = .scaleToFill
    }
}
