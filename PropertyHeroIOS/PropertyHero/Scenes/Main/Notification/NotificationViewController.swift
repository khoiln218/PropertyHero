//
//  NotificationViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then

final class NotificationViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    
    // MARK: - Properties
    
    var viewModel: NotificationViewModel!
    var disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showCoomingSoon(self.container)
    }
    
    deinit {
        logDeinit()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [weak self] _ in
            self?.rotateChanged()
        }
    }
    
    // MARK: - Methods
    
    private func configView() {
        
    }
    
    func bindViewModel() {
        let input = NotificationViewModel.Input()
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
    
    func rotateChanged() {
        let width = Dimension.SCREEN_WIDTH
        let height = Dimension.SCREEN_HEIGHT
        self.container.subviews[0].frame.size.width = width
        self.container.subviews[0].frame.size.height = height
    }
}

// MARK: - Binders
extension NotificationViewController {
    
}

// MARK: - StoryboardSceneBased
extension NotificationViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
