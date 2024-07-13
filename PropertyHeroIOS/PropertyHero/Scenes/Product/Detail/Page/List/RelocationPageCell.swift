//
//  RelocationPageCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/15/23.
//

import UIKit

class RelocationPageCell: PageTableCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var adsClicked: ((_ relocation: Relocation) -> Void)?
    
    var data: [Relocation]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    private func configView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.do {
            $0.decelerationRate = UIScrollView.DecelerationRate.fast
            $0.register(cellType: RelocationCell.self)
        }
    }
    
    func bindViewModel(_ viewModel: [Relocation]) {
        data = viewModel
        collectionView.reloadData()
        layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource
extension RelocationPageCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: RelocationCell.self
        )
        .then {
            $0.bindViewModel(data![indexPath.row])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RelocationPageCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        adsClicked?(data![indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Dimension.SCREEN_WIDTH / 3
        let height = (width - 8.0) / 2
        return CGSize(width: width, height: height)
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
