//
//  CollectionViewController.swift
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

final class CollectionViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var viewpager: UIView!
    @IBOutlet weak var tabLayout: TabLayout!
    private var isInit = false
    
    // MARK: - Properties
    
    var viewModel: CollectionViewModel!
    var disposeBag = DisposeBag()
    private var tabSelected = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isInit {
            self.viewModel.navigator.initCollection(self)
            self.isInit = true
        }
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(collectionChanged),
                                               name: NSNotification.Name.collectionChanged,
                                               object: nil)
        tabLayout.do {
            $0.tabLayoutDelegate = self
            $0.indicatorSize = 0.0
            $0.fixedMode = true
            $0.font = .boldSystemFont(ofSize: 14)
            $0.currentFont = .boldSystemFont(ofSize: 14)
            $0.textColor = UIColor(hex: "#808080")!
            $0.currentTextColor = UIColor(hex: "#2b50f6")!
        }
        
        var tabs = [(title: String?, image: UIImage?)]()
        tabs.append((title: "Xem gần đây".uppercased(), nil))
        tabs.append((title: "Yêu thích".uppercased(), nil))
        tabLayout.addTabs(tabs: tabs)
        
    }
    
    func bindViewModel() {
        let input = CollectionViewModel.Input()
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
    
    @objc func collectionChanged() {
        switch(tabSelected) {
        case 0:
            NotificationCenter.default.post(
                name: Notification.Name.productViewChanged,
                object: nil)
        default:
            NotificationCenter.default.post(
                name: Notification.Name.favoriteChanged,
                object: nil)
        }
    }
}

extension CollectionViewController: TabLayoutDelegate {
    func tabLayout(tabLayout: TabLayout, index: Int) {
        switch(index) {
        case 0:
            self.viewModel.navigator.toCollectionMenu(self, tab: .view)
        default:
            self.viewModel.navigator.toCollectionMenu(self, tab: .favorite)
        }
        tabSelected = index
    }
}

// MARK: - StoryboardSceneBased
extension CollectionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
