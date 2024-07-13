//
//  AccountInfoViewModel.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/31/23.
//

import MGArchitecture
import RxSwift
import RxCocoa
import Dto

struct AccountInfoViewModel {
    let navigator: AccountInfoNavigatorType
    let useCase: AccountInfoUseCaseType
}

// MARK: - ViewModel
extension AccountInfoViewModel: ViewModel {
    struct Input {
        let trigger: Driver<Void>
        let gender: Driver<Int>
        let fullname: Driver<String>
        let phoneNumber: Driver<String>
        let address: Driver<String>
        let birthday: Driver<Date>
        let province: Driver<Province>
        let district: Driver<District>
        let update: Driver<Void>
    }
    
    struct Output {
        @Property var data = [String: Any]()
        @Property var gender: Int?
        @Property var birthday: Date?
        @Property var province: Province?
        @Property var district: District?
        @Property var fullnameValidation = ValidationResult.success(())
        @Property var phoneNumberValidation = ValidationResult.success(())
        @Property var isSuccessful: Bool?
        @Property var error: Error?
        @Property var isLoading = false
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let errorTracker = ErrorTracker()
        let activityIndicator = ActivityIndicator()
        
        let account = input.trigger
            .flatMapLatest {
                self.useCase.accountInfo(AccountStorage().getAccount().Id)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let provinceList = input.trigger
            .flatMapLatest {
                self.useCase.getProvinces()
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let defaultProvince = Driver.combineLatest(account, provinceList)
            .map { res in
                res.1.first { $0.Id == res.0.ProvinceID } ?? res.1.first
            }
            .unwrap()
        
        let province = Driver.merge(input.province, defaultProvince)
        
        province
            .drive(output.$province)
            .disposed(by: disposeBag)
        
        let districtList = province
            .flatMapLatest { province in
                self.useCase.getDistricts(province.Id)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        let defaultDistrict = Driver.combineLatest(account, districtList)
            .map { res in
                res.1.first { $0.Id == res.0.DistrictID } ?? res.1.first
            }
            .unwrap()
        
        let district = Driver.merge(input.district, defaultDistrict)
        
        district
            .drive(output.$district)
            .disposed(by: disposeBag)
        
        let defaultGender = account
            .map { $0.Gender }
        
        let gender = Driver.merge(input.gender, defaultGender)
        
        gender
            .drive(output.$gender)
            .disposed(by: disposeBag)
        
        let defaultBirthday = account
            .map { account -> Date in
                let formatterISO8086 = DateFormatter()
                formatterISO8086.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                formatterISO8086.timeZone = TimeZone(abbreviation: "UTC")
                return formatterISO8086.date(from: account.BirthDate) ?? Date()
            }
        
        let birthday = Driver.merge(input.birthday, defaultBirthday)
        
        birthday
            .drive(output.$birthday)
            .disposed(by: disposeBag)
        
        let data = Driver.combineLatest(account, provinceList, districtList)
            .map { ["account": $0.0, "provinces": $0.1, "districts": $0.2] }
        
        data
            .drive(output.$data)
            .disposed(by: disposeBag)
        
        let defaultFullname = account
            .map { $0.FullName }
        
        let fullname = Driver.merge(input.fullname, defaultFullname)
        
        let fullnameValidation = Driver.combineLatest(fullname, input.update)
            .map { $0.0 }
            .map(useCase.validateFullname(_:))
        
        fullnameValidation
            .drive(output.$fullnameValidation)
            .disposed(by: disposeBag)
        
        let defaultPhoneNumber = account
            .map { $0.PhoneNumber }
        
        let phoneNumber = Driver.merge(input.phoneNumber, defaultPhoneNumber)
        
        let phoneNumberValidation = Driver.combineLatest(phoneNumber, input.update)
            .map { $0.0 }
            .map(useCase.validatePhoneNumber(_:))
        
        phoneNumberValidation
            .drive(output.$phoneNumberValidation)
            .disposed(by: disposeBag)
        
        let defaultAddress = account
            .flatMapLatest {
                Driver.just($0.Address)
            }
        
        let address = Driver.merge(input.address, defaultAddress)
        
        let isNextEnabled = Driver.and(
            fullnameValidation.map { $0.isValid },
            phoneNumberValidation.map { $0.isValid }
        ).startWith(true)
        
        let update = input.update
            .withLatestFrom(isNextEnabled)
            .filter { $0 }
            .withLatestFrom(Driver.combineLatest(
                account,
                fullname,
                gender,
                birthday,
                phoneNumber,
                address,
                province,
                district
            ))
            .flatMapLatest { account, fullname, gender, birthday, phoneNumber, address, province, district in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let birthdayStr = formatter.string(from: birthday)
                
                let formatterISO8086 = DateFormatter()
                formatterISO8086.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                formatterISO8086.timeZone = TimeZone(abbreviation: "UTC")
                let issueDate = formatterISO8086.date(from: account.IssuedDate) ?? Date()
                let issueDateStr = formatter.string(from: issueDate)
                let request = Account(Id: account.Id, FullName: fullname, Gender: gender, BirthDate: birthdayStr, PhoneNumber: phoneNumber, Email: account.Email, Address: address, CountryID: account.CountryID, ProvinceID: province.Id, DistrictID: district.Id, IDCode: account.IDCode, IssuedDate: issueDateStr, IssuedPlace: account.IssuedPlace)
                return self.useCase.updateInfo(request)
                    .trackError(errorTracker)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            }
        
        update
            .drive(output.$isSuccessful)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asDriver()
            .drive(output.$isLoading)
            .disposed(by: disposeBag)
        
        errorTracker
            .asDriver()
            .drive(output.$error)
            .disposed(by: disposeBag)
        
        return output
    }
}
