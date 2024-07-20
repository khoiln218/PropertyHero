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
    @IBOutlet weak var collectionView: PagingCollectionView!
    
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
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: ProductCell.self)
        }
    }
    
    func bindViewModel() {
        let input = ProductListViewModel.Input(
            load: Driver.just(()),
            reload: collectionView.refreshTrigger,
            loadMore: collectionView.loadMoreTrigger,
            selectProduct: collectionView.rx.itemSelected.asDriver(),
            filter: filter.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$distance
            .asDriver()
            .drive(onNext: { [unowned self] distance in
                if let distance = distance {
                    if distance == 0 {
                        self.collectionView.refreshFooter = nil
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
                self.collectionView.reloadData()
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
            .drive(collectionView.isRefreshing)
            .disposed(by: disposeBag)
        
        output.$isLoadingMore
            .asDriver()
            .drive(collectionView.isLoadingMore)
            .disposed(by: disposeBag)
        
        output.$isEmpty
            .asDriver()
            .drive(collectionView.isEmpty)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: ProductCell.self
        )
        .then {
            $0.addBorders(edges: [.bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
            $0.bindViewModel(products[indexPath.row])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = 84.0 + 16.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - StoryboardSceneBased
extension ProductListViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
