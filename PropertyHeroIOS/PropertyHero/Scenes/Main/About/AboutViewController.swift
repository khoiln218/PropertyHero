//
//  AboutViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 9/2/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then

final class AboutViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fbBtn: UIImageView!
    @IBOutlet weak var ggBtn: UIImageView!
    
    // MARK: - Properties
    
    var viewModel: AboutViewModel!
    var disposeBag = DisposeBag()
    
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
        title = "Thông tin về Property Hero"
        self.fbBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFacebook(_:))))
        self.ggBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGoogle(_:))))
    }
    
    @objc func onFacebook(_ sender: UITapGestureRecognizer) {
        UIApplication.tryURL(urls: [
            "fb://page/hellorent.vn", // App
            "https://www.facebook.com/hellorent.vn" // Website if app fails
        ])
    }
    
    @objc func onGoogle(_ sender: UITapGestureRecognizer) {
        UIApplication.tryURL(urls: [
            "https://plus.google.com/u/0/communities/114405969678787462416" // App
        ])
    }
    
    func bindViewModel() {
        let input = AboutViewModel.Input()
        _ = viewModel.transform(input, disposeBag: disposeBag)
    }
}

// MARK: - Binders
extension AboutViewController {
    
}

// MARK: - StoryboardSceneBased
extension AboutViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
