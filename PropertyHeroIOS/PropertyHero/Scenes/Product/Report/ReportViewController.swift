//
//  ReportViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/24/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import DLRadioButton

final class ReportViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var warningCompleted: DLRadioButton!
    @IBOutlet weak var inputReport: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    // MARK: - Properties
    
    var viewModel: ReportViewModel!
    var disposeBag = DisposeBag()
    let warningType = PublishSubject<Int>()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeBackButtonTitle()
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        sendBtn.layer.cornerRadius = 3
        sendBtn.layer.masksToBounds = true
        
        title = "Báo thông tin ảo"
        
        inputReport.layer.borderColor = UIColor(hex: "#CFD8DC")?.cgColor
        inputReport.layer.borderWidth = 1
        inputReport.layer.cornerRadius = 3
        inputReport.layer.masksToBounds = true
        inputReport.delegate = self
        
        sendBtn.backgroundColor = UIColor(hex: "#E0E0E0")
        sendBtn.titleLabel?.textColor = .white
    }
    
    @IBAction func warningCompletedChecked(_ sender: DLRadioButton) {
        warningType.onNext(0)
        
        sendBtn.isEnabled = true
        sendBtn.backgroundColor = UIColor(hex: "#2B50F6")
        sendBtn.titleLabel?.textColor = .white
    }
    
    @IBAction func warningInfoChecked(_ sender: DLRadioButton) {
        warningType.onNext(1)
        
        sendBtn.isEnabled = true
        sendBtn.backgroundColor = UIColor(hex: "#2B50F6")
        sendBtn.titleLabel?.textColor = .white
    }
    
    func bindViewModel() {
        let input = ReportViewModel.Input(
            warningType: warningType.asDriverOnErrorJustComplete(),
            content: inputReport.rx.text.orEmpty.asDriver(),
            report: sendBtn.rx.tap.asDriver()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$isSuccessful
            .asDriver()
            .drive(onNext: { [unowned self] isSuccessful in
                if let isSuccessful = isSuccessful {
                    if isSuccessful {
                        self.showAutoCloseMessage(image: nil, title: nil, message: "Cảm ơn bạn đã phản hồi!") {
                            self.viewModel.navigator.goBack()
                        }
                    } else {
                        self.showAutoCloseMessage(image: nil, title: nil, message: "Bạn đã phản hồi quá 3 lần cho một tin rao, vui lòng kiểm tra và thử lại") {
                            self.viewModel.navigator.goBack()
                        }
                    }
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
    }
}

// MARK: - Binders
extension ReportViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if textView.isFirstResponder {
            textView.text = nil
            textView.textColor = UIColor(hex: "#424242")
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            textView.textColor = UIColor(hex: "#808080")
            textView.text = "Nhập mô tả thêm"
        }
    }
}

// MARK: - StoryboardSceneBased
extension ReportViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.product
}
