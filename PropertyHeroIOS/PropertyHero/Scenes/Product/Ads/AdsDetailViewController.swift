//
//  AdsDetailViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then

final class AdsDetailViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var thumbnail: UIImageView!
    
    // MARK: - Properties
    
    var viewModel: AdsDetailViewModel!
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
        title = "Dịch vụ chuyển nhà"
    }
    
    func bindViewModel() {
        let input = AdsDetailViewModel.Input()
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$relocation
            .asDriver()
            .drive(onNext: { [unowned self] relocation in
                if let relocation = relocation {
                    if let companyName = relocation.CompanyName {
                        self.title = companyName
                    }
                    self.thumbnail.setImage(with: URL(string: relocation.ImageDetails))
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Binders
extension AdsDetailViewController {
    
}

// MARK: - StoryboardSceneBased
extension AdsDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
