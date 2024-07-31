//
//  HotPropertyCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 7/14/24.
//

import UIKit

class HotPropertyCell: PageCollectionCell {
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var list: UICollectionView!
    @IBOutlet weak var action: UIButton!
    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    
    var data: PageSectionViewModel<Product>?
    var selectProduct: ((_ product: Product) -> Void)?
    var viewMore: ((_ index: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView() {
        list.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: HotCell.self)
        }
        
        setupCollectionViewLayout()
        
        let color: UIColor = UIColor(hex: "#486BF6")!
        let font:UIFont = .italicSystemFont(ofSize: 17)
        let attHeader: NSMutableAttributedString = NSMutableAttributedString(string: "Tìm kiếm cho thuê Bất Động Sản")
        attHeader.setAttributes([.font: font, .foregroundColor: color], range: NSRange(location:"Tìm kiếm cho thuê ".count , length: "Bất Động Sản".count))
        self.header.attributedText = attHeader
        
        action.layer.cornerRadius = 8
        action.layer.borderWidth = 1
        action.layer.borderColor = UIColor(hex: "#E1E1E1")!.cgColor
        action.setTitleColor(.black, for: .normal)
    }
    
    func bindViewModel(_ viewModel: PageSectionViewModel<Product>) {
        data = viewModel
        var height = 0.0
        if viewModel.items.count > 2 {
            height = 2*Dimension.HOT_HEIGHT
        } else if viewModel.items.count > 0 {
            height = Dimension.HOT_HEIGHT
        }
        heightConstrain.constant = CGFloat(height)
        action.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMore(_:))))
        action.isUserInteractionEnabled = true
        list.reloadData()
    }
    
    @objc func onMore(_ sender: UIButton) {
        viewMore?(data!.index)
    }
    
    func setupCollectionViewLayout() {
        if let layout = list.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 0
            
            let itemWidth = Dimension.HOT_WIDTH
            let itemHeight = Dimension.HOT_HEIGHT
            
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HotPropertyCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: HotCell.self
        )
        .then {
            $0.bindViewModel(data!.items[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectProduct?(data!.items[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HotPropertyCell: UICollectionViewDelegateFlowLayout {
    
}
