//
//  SearchViewController.swift
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

final class SearchViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tabLayout: TabLayout!
    @IBOutlet weak var viewpager: UIView!
    
    // MARK: - Properties
    
    var viewModel: SearchViewModel!
    var disposeBag = DisposeBag()
    private var isInit = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isInit {
            self.viewModel.navigator.initSearch(self)
            self.isInit = true
        }
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        tabLayout.do {
            $0.tabLayoutDelegate = self
            $0.indicatorSize = 0.0
            $0.fixedMode = true
            $0.font = .boldSystemFont(ofSize: 14)
            $0.currentFont = .boldSystemFont(ofSize: 14)
            $0.textColor = UIColor(hex: "#808080")!
            $0.currentTextColor = UIColor(hex: "#424242")!
        }
        
        var tabs = [(title: String?, image: UIImage?)]()
        tabs.append((title: "Tỉnh thành".uppercased(), nil))
        tabs.append((title: "Địa điểm".uppercased(), nil))
        tabLayout.addTabs(tabs: tabs)
    }
    
    func bindViewModel() {
        let input = SearchViewModel.Input()
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
}

extension SearchViewController: TabLayoutDelegate {
    func tabLayout(tabLayout: TabLayout, index: Int) {
        switch(index) {
        case 0:
            self.viewModel.navigator.toSearchMenu(self, tab: .location)
        default:
            self.viewModel.navigator.toSearchMenu(self, tab: .marker)
        }
    }
}

// MARK: - StoryboardSceneBased
extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
