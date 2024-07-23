//
//  AboutViewController.swift
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

final class AboutViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: AboutViewModel!
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        title = "Thông tin về Property Hero"
    }
    
    func bindViewModel() {
        let input = AboutViewModel.Input()
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
}

// MARK: - Binders
extension AboutViewController {
    
}

// MARK: - StoryboardSceneBased
extension AboutViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
