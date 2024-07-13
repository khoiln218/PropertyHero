//
//  RecommendProductCell.swift
//  CleanArchitecture
//
//  Created by KHOI LE on 5/30/21.
//  Copyright © 2021 Sun Asterisk. All rights reserved.
//

import UIKit

class FurniturePageCell: PageTableCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [Furniture]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.do {
            $0.decelerationRate = UIScrollView.DecelerationRate.fast
            $0.register(cellType: FurnitureCell.self)
        }
    }
    
    func bindViewModel(_ viewModel: [Furniture]) {
        data = viewModel
        collectionView.reloadData()
        layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource
extension FurniturePageCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: FurnitureCell.self
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FurniturePageCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 146 + 48)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
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

