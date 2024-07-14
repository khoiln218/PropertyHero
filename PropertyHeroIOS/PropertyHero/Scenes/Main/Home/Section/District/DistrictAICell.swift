//
//  DistrictAICell.swift
//  PropertyHero
//
//  Created by KHOI LE on 7/14/24.
//

import UIKit

class DistrictAICell: PageCollectionCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var list: UICollectionView!
    
    var data: PageSectionViewModel<DistrictSuggest>?
    var selectDistrict: ((_ district: DistrictSuggest) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView() {
        list.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: DistrictCell.self)
        }
        
        setupCollectionViewLayout()
    }
    
    func bindViewModel(_ viewModel: PageSectionViewModel<DistrictSuggest>) {
        data = viewModel
        name.text = viewModel.title
        list.reloadData()
    }
    
    func setupCollectionViewLayout() {
        if let layout = list.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing: CGFloat = 0
            
            let itemWidth = 250
            let itemHeight = 115
            
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.minimumInteritemSpacing = spacing
            layout.minimumLineSpacing = spacing
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DistrictAICell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: DistrictCell.self
        )
        .then {
            $0.bindViewModel(data!.items[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDistrict?(data!.items[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DistrictAICell: UICollectionViewDelegateFlowLayout {
    
}
