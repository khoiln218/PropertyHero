//
//  AreaSectionCell.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/13/23.
//

import UIKit

class AreaSectionCell: PageCollectionCell {
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var viewmore: UILabel!
    
    var selectMarker: ((_ marker: Marker) -> Void)?
    var viewMore: ((_ index: Int) -> Void)?
    
    var data: PageSectionViewModel<Marker>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configView()
    }
    
    private func configView() {
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: AreaCell.self)
        }
        
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor(hex: "#ECEFF1")?.cgColor
    }
    
    func bindViewModel(_ viewModel: PageSectionViewModel<Marker>) {
        data = viewModel
        if viewModel.index == 2 {
            viewmore.text = ""
            viewmore.textColor = UIColor(hex: "#F44336")
            icon.image = UIImage(named: "ic_drawable_korea")
        } else {
            viewmore.text = "Khu vực khác >"
            viewmore.textColor = UIColor(hex: "#01A0B9")
            icon.image = UIImage(named: "ic_drawable_vn")
        }
        name.text = viewModel.title
        viewmore.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMore(_:))))
        viewmore.isUserInteractionEnabled = true
        collectionView.reloadData()
    }
    
    @objc func onMore(_ sender: UIButton) {
        viewMore?(data!.index)
    }
}

// MARK: - UICollectionViewDataSource
extension AreaSectionCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: AreaCell.self
        )
        .then {
            $0.bindViewModel(data!.items[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectMarker?(data!.items[indexPath.row])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AreaSectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Dimension.AREA_ITEM_WIDTH, height: Dimension.AREA_ITEM_HEIGHT)
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
