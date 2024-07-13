//
//  FavoriteViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import MGLoadMore

final class FavoriteViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var tableView: PagingTableView!
    
    // MARK: - Properties
    
    var viewModel: FavoriteViewModel!
    var disposeBag = DisposeBag()
    var products = [Product]()
    
    var reload = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteChanged), name:
                                                UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoriteChanged),
                                               name: NSNotification.Name.logout,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoriteChanged),
                                               name: NSNotification.Name.loginSuccess,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(favoriteChanged),
                                               name: NSNotification.Name.favoriteChanged,
                                               object: nil)
        
        tableView.do {
            $0.dataSource = self
            $0.refreshFooter = nil
            $0.register(cellType: ProductTableCell.self)
        }
    }
    
    func bindViewModel() {
        let input = FavoriteViewModel.Input(
            trigger: Driver.merge(Driver.just(()) , reload.asDriverOnErrorJustComplete(), tableView.refreshTrigger),
            selected: tableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$products
            .asDriver()
            .drive(onNext: { [unowned self] products in
                self.products = products
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.$error
            .asDriver()
            .unwrap()
            .drive(rx.error)
            .disposed(by: disposeBag)
        
        output.$isLoading
            .asDriver()
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        
        output.$isReloading
            .asDriver()
            .drive(tableView.isRefreshing)
            .disposed(by: disposeBag)
        
        output.$isEmpty
            .asDriver()
            .drive(tableView.isEmpty)
            .disposed(by: disposeBag)
    }
    
    @objc func favoriteChanged() {
        reload.onNext(())
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.products[indexPath.row]
        return tableView.dequeueReusableCell(
            for: indexPath,
            cellType: ProductTableCell.self
        )
        .then {
            $0.selectionStyle = .none
            $0.separatorInset = UIEdgeInsets.zero
            $0.bindViewModel(product)
        }
    }
}

// MARK: - StoryboardSceneBased
extension FavoriteViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
