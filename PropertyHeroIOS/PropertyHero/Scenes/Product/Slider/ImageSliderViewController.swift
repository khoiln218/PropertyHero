//
//  ImageSliderViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import ImageSlideshow

final class ImageSliderViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var slider: ImageSlideshow!
    
    // MARK: - Properties
    
    var viewModel: ImageSliderViewModel!
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        title = "Hình ảnh chi tiết"
        
        slider.slideshowInterval = 5.0
        slider.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = .clear
        pageIndicator.pageIndicatorTintColor = .clear
        slider.pageIndicator = pageIndicator
        
        slider.activityIndicator = DefaultActivityIndicator()
    }
    
    func bindViewModel() {
        let input = ImageSliderViewModel.Input()
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$data
            .asDriver()
            .drive(onNext: { [unowned self] data in
                if let data = data {
                    if let images = data["images"] as? String, let position = data["position"] as? Int {
                        slider.contentScaleMode = UIViewContentMode.scaleAspectFit
                        
                        let pageIndicator = UIPageControl()
                        pageIndicator.currentPageIndicatorTintColor = .clear
                        pageIndicator.pageIndicatorTintColor = .clear
                        slider.pageIndicator = pageIndicator
                        
                        slider.activityIndicator = DefaultActivityIndicator()
                        
                        var sdWebImageSource = [SDWebImageSource]()
                        let images = images.components(separatedBy: ", ")
                        for image in images {
                            sdWebImageSource.append(SDWebImageSource(url: URL(string: image)!, placeholder: UIImage(named: "empty")))
                        }
                        slider.setImageInputs(sdWebImageSource)
                        slider.setCurrentPage(position, animated: false)
                        slider.pauseTimer()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Binders
extension ImageSliderViewController {
    
}

// MARK: - StoryboardSceneBased
extension ImageSliderViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
