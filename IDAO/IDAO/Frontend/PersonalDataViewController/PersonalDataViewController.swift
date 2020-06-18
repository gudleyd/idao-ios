//
//  RegistrationViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 28.03.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation
import UIKit
import Eureka


class PersonalDataViewController: FormViewController {
    
    enum PersonalDataViewStyle {
        case registration
        case view
    }
    
    var user: User?
    var style: PersonalDataViewStyle = .view
    
    func setStyle(style: PersonalDataViewStyle) {
        self.style = style
    }
    
    func setUser(user: User?) {
        self.user = user
    }
    
    func rebuild() {
        self.buildForm()
    }
    
    func dataForRegistration() -> UserWithPasswordAndData {
        return UserWithPasswordAndData(name: (self.form.rowBy(tag: "name") as? TextRow)?.value ?? "",
                                       username: (self.form.rowBy(tag: "username") as? TextRow)?.value ?? "",
                                       password: (self.form.rowBy(tag: "password") as? PasswordRow)?.value ?? "",
                                       email: (self.form.rowBy(tag: "email") as? EmailRow)?.value ?? "",
                                       birthday: (self.form.rowBy(tag: "birthday") as? DateRow)?.value ?? Date(),
                                       phoneNumber: (self.form.rowBy(tag: "phoneNumber") as? PhoneRow)?.value ?? "",
                                       gender: (self.form.rowBy(tag: "gender") as? ActionSheetRow<String>)?.value ?? "",
                                       countryOfResidence: (self.form.rowBy(tag: "countryOfResidence") as? PickerInputRow<String>)?.value ?? "",
                                       university: (self.form.rowBy(tag: "university") as? TextRow)?.value ?? "",
                                       studyProgram: (self.form.rowBy(tag: "studyProgram") as? TextRow)?.value ?? "",
                                       levelOfStudy: (self.form.rowBy(tag: "levelOfStudy") as? ActionSheetRow<String>)?.value ?? "",
                                       company: (self.form.rowBy(tag: "company") as? TextRow)?.value ?? "")
    }
    
    func personalDataFromForm() -> User.PersonalData? {
        if self.style == .view,
            let user = self.user {
            return User.PersonalData(userId: user.personalData.userId,
                                     email: user.personalData.email,
                                     birthday: user.personalData.birthday,
                                     phoneNumber: (self.form.rowBy(tag: "phoneNumber") as? PhoneRow)?.value ?? "",
                                     gender: user.personalData.gender,
                                     countryOfResidence: (self.form.rowBy(tag: "countryOfResidence") as? PickerInputRow<String>)?.value ?? "",
                                     university: (self.form.rowBy(tag: "university") as? TextRow)?.value ?? "",
                                     studyProgram: (self.form.rowBy(tag: "studyProgram") as? TextRow)?.value ?? "",
                                     levelOfStudy: (self.form.rowBy(tag: "levelOfStudy") as? ActionSheetRow<String>)?.value ?? "",
                                     company: (self.form.rowBy(tag: "company") as? TextRow)?.value ?? "",
                                     registrationDate: user.personalData.registrationDate)
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelRegistration))
        
        self.buildForm()
    }
    
    @objc func cancelRegistration() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func buildForm() {
        self.form.removeAll()
        
        self.title = style == .view ? "Personal Data" : "Registration"
        
        self.buildPersonalInformationSection()
        self.buildOccupationSection()
        self.buildCredentialsSection()
        
        form +++ Section()
            
            <<< ButtonRow("registerButton") {
                $0.title = "Register"
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
            }
            .onCellSelection { [weak self] (cell, row) in
                let invalid = self?.form.validate()
                if invalid ?? [] == [] {
                    guard let agreementViewController = UIStoryboard(name: "Agreement", bundle: .main).instantiateInitialViewController() as? AgreementViewController else { return }
                    agreementViewController.onAgree = {
                        IdaoManager.shared.register(userData: self?.dataForRegistration()) { status in
                            DispatchQueue.main.async {
                                switch status {
                                case .success:
                                    self?.present(AlertViewsFactory.newAlert(title: "Success", message: """
                                        You successfully created account.
                                        Please, check your email to complete registration
                                        Please, check your spam folder
                                    """, handler: { _ in self?.dismiss(animated: true)}), animated: true, completion: nil)
                                case .inUse(let details):
                                    self?.present(AlertViewsFactory.newAlert(title: "Error", message: details), animated: true)
                                default:
                                    self?.present(AlertViewsFactory.unknownError(), animated: true)
                                }
                            }
                        }
                    }
                    let newNavController = UINavigationController(rootViewController: agreementViewController)
                    self?.present(newNavController, animated: true) {
                        if let rtfPath = Bundle.main.url(forResource: "RegistrationAgreement", withExtension: "rtf"),
                            let attributedStringWithRtf: NSAttributedString = try? NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil) {
                            agreementViewController.loadAgreement(attributedStringWithRtf: attributedStringWithRtf)
                        } else {
                            return
                        }
                    }
                }
            }
            
            <<< ButtonRow("saveChangesButton") {
                $0.title = "Save Changes"
                $0.hidden = Condition.init(booleanLiteral: self.style != .view)
            }
            .onCellSelection { [weak self] (cell, row) in
                let invalid = self?.form.validate()
                if invalid ?? [] == [],
                    let data = self?.personalDataFromForm() {
                    
                    IdaoManager.shared.changeUserPersonalData(userData: data) { status in
                        IdaoStorage.appUser.update { }
                        DispatchQueue.main.async {
                            switch status {
                            case .success:
                                self?.dismiss(animated: true)
                            case .unknownError:
                                self?.present(AlertViewsFactory.unknownError(), animated: true)
                            }
                        }
                    }
                }
            }
    }
    
    func buildPersonalInformationSection() {
        form +++ Section("Personal Information")
            <<< TextRow("name") {
                $0.title = "Name"
                $0.placeholder = "Your Name"
                $0.titlePercentage = 0.4
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
                $0.value = user?.account.name
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                cell.textField.keyboardType = .asciiCapable
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }

            <<< DateRow("birthday"){
                $0.title = "Birthday"
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
                $0.value = user?.personalData.birthday
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }

            <<< PhoneRow("phoneNumber") {
                $0.title = "Phone number"
                $0.placeholder = "Phone number"
                $0.add(rule: RuleRequired())
                $0.titlePercentage = 0.4
                $0.value = user?.personalData.phoneNumber
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }

            <<< ActionSheetRow<String>("gender") {
                $0.title = "Gender"
                $0.options = ["male", "female", "not specified"]
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
                $0.value = user?.personalData.gender ?? "not specified"
            }
    }
    
    func buildOccupationSection() {
        form +++ Section("Occupation")
            <<< ActionSheetRow<String>("currentOccupation") {
                $0.title = "Current occupation"
                $0.options = ["Student", "Employee"]
                $0.value = (user?.personalData.company ?? "") == "" ? "Student" : "Employee"
            }
            <<< TextRow("university") {
                $0.title = "University"
                $0.placeholder = "University"
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value! != "Student")
                })
                $0.value = user?.personalData.university
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                cell.textField.keyboardType = .asciiCapable
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
            
            <<< TextRow("studyProgram") {
                $0.title = "Study Program"
                $0.placeholder = "Study Program"
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value! != "Student")
                })
                $0.value = user?.personalData.studyProgram
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                cell.textField.keyboardType = .asciiCapable
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
            
            <<< ActionSheetRow<String>("levelOfStudy") {
                $0.title = "Level Of Study"
                $0.options = ["Bachelor", "Master", "PhD"]
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value! != "Student")
                })
                $0.value = user?.personalData.levelOfStudy ?? "Bachelor"
            }
            
            <<< TextRow("company") {
                $0.title = "Company"
                $0.placeholder = "Company"
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value != "Employee")
                })
                $0.value = user?.personalData.company
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                cell.textField.keyboardType = .asciiCapable
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
    }
    
    func buildCredentialsSection() {
        form +++ Section("Credentials")

            <<< PickerInputRow<String>("countryOfResidence") {
                $0.title = "Country"
                $0.options = getCountries()
                $0.add(rule: RuleRequired())
                $0.value = user?.personalData.countryOfResidence
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.textColor = .red
                }
            }
            
            <<< EmailRow("email") {
                $0.title = "Email"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
                $0.value = user?.personalData.email
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                cell.textField.keyboardType = .asciiCapable
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            
            <<< TextRow("username") {
                $0.title = "Username"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                cell.textField.keyboardType = .asciiCapable
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }

            <<< PasswordRow("password") {
                $0.title = "Password"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }

            <<< PasswordRow() {
                $0.title = "Confirm Password"
                $0.add(rule: RuleEqualsToRow(form: form, tag: "password", msg: "Passwords must match"))
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
    }
}
