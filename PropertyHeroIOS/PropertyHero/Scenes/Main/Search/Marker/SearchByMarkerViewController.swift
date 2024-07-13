//
//  SearchByMarkerViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/11/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then

final class SearchByMarkerViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var filterBar: UIView!
    @IBOutlet weak var searchBar: DesignableUITextField!
    @IBOutlet weak var provinceBtn: UIView!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var viewModel: SearchByMarkerViewModel!
    var disposeBag = DisposeBag()
    
    private var provinces = [Province]()
    private var markers = [Marker]()
    private var provinceSelected:Province!
    private var markerType: MarkerType!
    
    var provinceSubject = PublishSubject<Province>()
    var keywordSubject = PublishSubject<String>()
    var selectedMarker = PublishSubject<Marker>()
    
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
        title = "Tìm khu vực"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(provinceChanged(_:)),
                                               name: NSNotification.Name.settingChanged,
                                               object: nil)
        
        self.tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: MarkerCell.self)
        }
        
        self.filterBar.layer.borderWidth = 0.3
        self.filterBar.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        self.filterBar.layer.masksToBounds = true
        
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        self.searchBar.layer.cornerRadius = 3
        self.searchBar.layer.masksToBounds = true
        self.searchBar.returnKeyType = .search
        self.searchBar.delegate = self
        
        self.provinceBtn.layer.borderWidth = 1
        self.provinceBtn.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        self.provinceBtn.layer.cornerRadius = 3
        self.provinceBtn.layer.masksToBounds = true
        
        self.provinceBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSelectedProvince(_:))))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func onSelectedProvince(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "   ", message: "   ", preferredStyle: .actionSheet)
        
        let messageAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black]
         let messageString = NSAttributedString(string: "Chọn Tỉnh/Thành phố", attributes: messageAttributes)
        alert.setValue(messageString, forKey: "attributedMessage")
        
        for province in self.provinces {
            alert.addAction(UIAlertAction(title: province.Name, style: .default , handler:{ [unowned self] _ in
                self.provinceSelected = province
                self.provinceSubject.onNext(self.provinceSelected)
                self.provinceLabel.text = province.Name
            }))
        }
        alert.addAction(UIAlertAction(title: "Đóng", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func bindViewModel() {
        let input = SearchByMarkerViewModel.Input(
            trigger: Driver.just(()),
            province: provinceSubject.asDriverOnErrorJustComplete(),
            keyword: Driver.merge(keywordSubject.asDriverOnErrorJustComplete(), searchBar.rx.text.orEmpty.asDriver().debounce(.milliseconds(880))),
            selectMarker: selectedMarker.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$markerType
            .asDriver()
            .drive(onNext: { [unowned self] type in
                if let type = type {
                    self.markerType = type
                    switch(type) {
                    case .attr:
                        self.searchBar.placeholder = "Nhập tên khu vực"
                    default:
                        self.searchBar.placeholder = "Tên tòa nhà, Trường đại học"
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.$proinces
            .asDriver()
            .drive(onNext: { [unowned self] provinces in
                if let provinces = provinces {
                    self.provinceSelected = provinces.first{ $0.Id == DefaultStorage().getDefaultProvince() } ?? provinces.first
                    self.provinceSubject.onNext(self.provinceSelected)
                    self.provinceLabel.text = self.provinceSelected.Name
                    self.provinces = provinces
                }
            })
            .disposed(by: disposeBag)
        
        output.$markers
            .asDriver()
            .drive(onNext: { [unowned self] markers in
                if let markers = markers {
                    self.markers = markers
                    self.tableView.reloadData()
                }
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
        
        output.$isEmpty
            .asDriver()
            .drive(tableView.isEmpty)
            .disposed(by: disposeBag)
    }
    
    @objc func provinceChanged(_ notification: Notification) {
        self.provinceSelected = self.provinces.first{ $0.Id == DefaultStorage().getDefaultProvince() } ?? self.provinces.first
        self.provinceSubject.onNext(self.provinceSelected)
        self.provinceLabel.text = self.provinceSelected.Name
    }
    
    func onChooseDistance(_ marker: Marker) {
        let alertViewController = UIAlertController(title: marker.Name, message: nil, preferredStyle: .alert)
        let distanceOne = UIAlertAction(title: "Bán kính 1km", style: .default, handler: { (_) in
            let newMarker = Marker(Id: marker.Id, Name: marker.Name, Latitude: marker.Latitude, Longitude: marker.Longitude, distance: 1.0)
            self.selectedMarker.onNext(newMarker)
        })
        let distanceThree = UIAlertAction(title: "Bán kính 3km", style: .default) { (_) in
            let newMarker = Marker(Id: marker.Id, Name: marker.Name, Latitude: marker.Latitude, Longitude: marker.Longitude, distance: 3.0)
            self.selectedMarker.onNext(newMarker)
        }
        let distanceFive = UIAlertAction(title: "Bán kính 5km", style: .default) { (_) in
            let newMarker = Marker(Id: marker.Id, Name: marker.Name, Latitude: marker.Latitude, Longitude: marker.Longitude, distance: 5.0)
            self.selectedMarker.onNext(newMarker)
        }
        let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel) { (_) in
        }
        alertViewController.addAction(distanceOne)
        alertViewController.addAction(distanceThree)
        alertViewController.addAction(distanceFive)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension SearchByMarkerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let marker = self.markers[indexPath.row]
        return tableView.dequeueReusableCell(
            for: indexPath,
            cellType: MarkerCell.self
        )
        .then {
            $0.selectionStyle = .none
            $0.bindViewModel(marker, markerType: self.markerType)
        }
    }
}

extension SearchByMarkerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let marker = self.markers[indexPath.row]
        if markerType == .attr {
            self.onChooseDistance(marker)
        } else {
            self.selectedMarker.onNext(marker)
        }
    }
}

extension SearchByMarkerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchBar {
            if let keyword = textField.text {
                self.keywordSubject.onNext(keyword)
            }
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}

// MARK: - StoryboardSceneBased
extension SearchByMarkerViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
