//
//  HeaderPageItemCell.swift
//  CleanArchitecture
//
//  Created by KHOI LE on 5/26/21.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit
import ImageSlideshow

class HeaderCell: PageCollectionCell {
    
    @IBOutlet weak var banners: ImageSlideshow!
    @IBOutlet weak var findAll: UIView!
    @IBOutlet weak var findApartment: UIView!
    @IBOutlet weak var findRoom: UIView!
    
    var selectBanner: ((_ banner: Banner) -> Void)?
    var selectOption: ((_ option: OptionChoice) -> Void)?
    
    var data: PageSectionViewModel<Banner>!
    var position = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let colorDivider = UIColor(hex: "#ECEFF1")!
        let borderWidth: CGFloat = 1
        findAll.addBorders(edges: .top, color: colorDivider, width: borderWidth)
        findAll.addBorders(edges: .bottom, color: colorDivider, width: borderWidth)
        findAll.addBorders(edges: .left, color: colorDivider, width: borderWidth)
        findApartment.addBorders(edges: .all, color: colorDivider, width: borderWidth)
        findRoom.addBorders(edges: .top, color: colorDivider, width: borderWidth)
        findRoom.addBorders(edges: .bottom, color: colorDivider, width: borderWidth)
        findRoom.addBorders(edges: .right, color: colorDivider, width: borderWidth)
        
        banners.slideshowInterval = 5.0
        banners.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = .clear
        pageIndicator.pageIndicatorTintColor = .clear
        banners.pageIndicator = pageIndicator
        
        banners.activityIndicator = DefaultActivityIndicator()
        banners.delegate = self
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        banners.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        selectBanner?(data.items[position])
    }
    
    func bindViewModel(_ viewModel: PageSectionViewModel<Banner>) {
        data = viewModel
        
        var sdWebImageSource = [SDWebImageSource]()
        for banner in data.items {
            sdWebImageSource.append(SDWebImageSource(urlString: banner.Thumbnail)!)
        }
        banners.setImageInputs(sdWebImageSource)
        
        
        findAll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOptionAll(_:))))
        findApartment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOptionApartment(_:))))
        findRoom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOptionRoom(_:))))
    }
    
    @objc func onOptionAll(_ sender: UITapGestureRecognizer) {
        selectOption?(.all)
    }
    
    @objc func onOptionApartment(_ sender: UITapGestureRecognizer) {
        selectOption?(.apartment)
    }
    
    @objc func onOptionRoom(_ sender: UITapGestureRecognizer) {
        selectOption?(.room)
    }
}

extension HeaderCell: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        self.position = page
    }
}
