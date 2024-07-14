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
    @IBOutlet weak var boderRoom: UIView!
    @IBOutlet weak var boderApartment: UIView!
    @IBOutlet weak var boderAll: UIView!
    
    var selectBanner: ((_ banner: Banner) -> Void)?
    var selectOption: ((_ option: OptionChoice) -> Void)?
    
    var data: PageSectionViewModel<Banner>!
    var position = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cornerRadius:CGFloat = 8
        let colorDivider = UIColor(hex: "#E1E1E1")!.cgColor
        
        boderRoom.layer.cornerRadius = cornerRadius
        boderRoom.layer.borderWidth = 1
        boderRoom.layer.borderColor = colorDivider
        boderApartment.layer.cornerRadius = cornerRadius
        boderApartment.layer.borderWidth = 1
        boderApartment.layer.borderColor = colorDivider
        boderAll.layer.cornerRadius = cornerRadius
        boderAll.layer.borderWidth = 1
        boderAll.layer.borderColor = colorDivider
        
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
