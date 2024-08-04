//
//  ProductListViewController.swift
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

final class ProductListViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var list: PagingTableView!
    
    // MARK: - Properties
    
    var viewModel: ProductListViewModel!
    var disposeBag = DisposeBag()
    
    private var products = [Product]()
    var filter = PublishSubject<Void>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
        
        let filterBtn = UIButton(type: .custom)
        filterBtn.setImage(UIImage(named: "vector_action_filter")!, for: .normal)
        filterBtn.addTarget(self, action: #selector(self.filterClick(_:)), for: UIControl.Event.touchUpInside)
        let filterCurrWidth = filterBtn.widthAnchor.constraint(equalToConstant: 24)
        filterCurrWidth.isActive = true
        let filterCurrHeight = filterBtn.heightAnchor.constraint(equalToConstant: 24)
        filterCurrHeight.isActive = true
        
        let rightBarButton = UIBarButtonItem(customView: filterBtn)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func filterClick(_ sender: Any) {
        self.filter.onNext(())
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        list.do {
            $0.dataSource = self
            $0.register(cellType: ProductCell.self)
        }
    }
    
    func bindViewModel() {
        let input = ProductListViewModel.Input(
            load: Driver.just(()),
            reload: list.refreshTrigger,
            loadMore: list.loadMoreTrigger,
            selected: list.rx.itemSelected.asDriver(),
            filter: filter.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$distance
            .asDriver()
            .drive(onNext: { [unowned self] distance in
                if let distance = distance {
                    if distance == 0 {
                        self.list.refreshFooter = nil
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.$title
            .asDriver()
            .drive(onNext: { [unowned self] title in
                if let title = title {
                    self.title = title
                }
            })
            .disposed(by: disposeBag)
        
        output.$products
            .asDriver()
            .drive(onNext: { [unowned self] products in
                self.products = products
                self.list.reloadData()
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
            .drive(list.isRefreshing)
            .disposed(by: disposeBag)
        
        output.$isLoadingMore
            .asDriver()
            .drive(list.isLoadingMore)
            .disposed(by: disposeBag)
        
        output.$isEmpty
            .asDriver()
            .drive(list.isEmpty)
            .disposed(by: disposeBag)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = self.products[indexPath.row]
        return tableView.dequeueReusableCell(
            for: indexPath,
            cellType: ProductCell.self
        )
        .then {
            $0.selectionStyle = .none
            $0.separatorInset = UIEdgeInsets.zero
            $0.bindViewModel(product)
        }
    }
}

// MARK: - StoryboardSceneBased
extension ProductListViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
