//
//  ProfileViewController.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/26/23.
//

import UIKit
import MGArchitecture
import RxSwift
import RxCocoa
import Reusable
import Then
import MGAPIService
import RSKImageCropper
import MBProgressHUD

final class ProfileViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var avatarBtn: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userInfo: UIView!
    @IBOutlet weak var changePw: UIView!
    @IBOutlet weak var deleteBtn: UIView!
    @IBOutlet weak var logoutBtn: UIView!
    
    // MARK: - Properties
    
    var viewModel: ProfileViewModel!
    var disposeBag = DisposeBag()
    var imagePicker: UIImagePickerController?
    var avatarData = PublishSubject<APIUploadData>()
    
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
        self.userInfo.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        if AccountStorage().getAccount().AccountType == AccountType.hero.rawValue {
            self.deleteBtn.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        } else {
            self.deleteBtn.addBorders(edges: [.bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        }
        self.logoutBtn.addBorders(edges: [.top, .bottom], color: UIColor(hex: "#ECEFF1")!, width: 1)
        self.avatarBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChooseAvatar(_:))))
        self.userInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onUserInfo(_:))))
        self.changePw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChange(_:))))
        self.deleteBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDelete(_:))))
        self.logoutBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onLogout(_:))))
        
        self.avatar.layer.borderWidth = 1.0
        self.avatar.layer.masksToBounds = false
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.cornerRadius = avatar.frame.size.width / 2
        self.avatar.clipsToBounds = true
        
        self.changePw.isHidden = AccountStorage().getAccount().AccountType != AccountType.hero.rawValue
        
        self.title = "Cá nhân"
    }
    
    @objc func onChooseAvatar(_ sender: UITapGestureRecognizer) {
        let alertViewController = UIAlertController(title: "Đổi ảnh đại diện", message: nil, preferredStyle: .alert)
        let camera = UIAlertAction(title: "Máy ảnh", style: .default, handler: { (_) in
            self.openCamera()
        })
        let gallery = UIAlertAction(title: "Bộ sưu tập", style: .default) { (_) in
            self.openGallary()
        }
        let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel) { (_) in
            //cancel
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @objc func onUserInfo(_ sender: UITapGestureRecognizer) {
        self.viewModel.navigator.toAccountInfo()
    }
    
    @objc func onChange(_ sender: UITapGestureRecognizer) {
        self.viewModel.navigator.toChangePassword()
    }
    
    @objc func onLogout(_ sender: UITapGestureRecognizer) {
        AccountStorage().logout()
        NotificationCenter.default.post(
            name: Notification.Name.logout,
            object: nil)
        self.viewModel.navigator.backHome()
        
    }
    
    @objc func onDelete(_ sender: UITapGestureRecognizer) {
        self.viewModel.navigator.toAccountDeletion()
    }
    
    func bindViewModel() {
        let input = ProfileViewModel.Input(
            trigger: Driver.just(()),
            avatar: avatarData.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.$account
            .asDriver()
            .drive(onNext: { [unowned self] account in
                avatar.setAvatarImage(with: URL(string: account.Avatar))
                fullname.text = account.FullName
                username.text = account.UserName
            })
            .disposed(by: disposeBag)
        
        output.$isSuccessful
            .asDriver()
            .drive(onNext: { [unowned self] isSuccessful in
                if let isSuccessful = isSuccessful {
                    if(isSuccessful) {
                        self.onSuccess()
                    } else {
                        self.onFails()
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
    
    func onSuccess() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name.avatarChanged,
                object: nil)
            self.showAutoCloseMessage(image: nil, title: nil, message: "Cập nhật thành công")
        }
    }
    
    func onFails() {
        DispatchQueue.main.async {
            self.showAutoCloseMessage(image: nil, title: nil, message: "Xảy ra lỗi. Vui lòng thử lại")
        }
    }
    
    func openCropImage(_ image: UIImage) {
        let imageCropVC = RSKImageCropViewController.init(image: image, cropMode: RSKImageCropMode.circle)
        imageCropVC.delegate = self;
        self.navigationController?.pushViewController(imageCropVC, animated: true)
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.offset.y = -30
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

// MARK: - Binders
extension ProfileViewController {
    fileprivate func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.imagePicker = UIImagePickerController()
            if let imagePicker = self.imagePicker {
                showLoading(true)
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            let alertWarning = UIAlertController(title: "Lỗi", message: "Thiết bị không hỗ trợ", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Hủy bỏ", style: .cancel) { (_) in
                print("Cancel")
            }
            alertWarning.addAction(cancel)
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    fileprivate func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            self.imagePicker = UIImagePickerController()
            if let imagePicker = self.imagePicker {
                showLoading(true)
                imagePicker.delegate = self  as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue) ] as? UIImage {
            self.openCropImage(image)
        } else if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue) ] as? UIImage {
            self.openCropImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.showLoading(false)
    }
}

extension ProfileViewController: RSKImageCropViewControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
        self.showLoading(false)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.avatar.image = croppedImage
        guard let imageData = croppedImage.jpegData(compressionQuality: 1.0) else { return }
        self.avatarData.onNext(APIUploadData(data: imageData, name: "uploaded_file", fileName: "avatar.jpg", mimeType: "multipart/form-data"))
        self.navigationController?.popViewController(animated: true)
        self.showLoading(false)
    }
}

// MARK: - StoryboardSceneBased
extension ProfileViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
