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
                self?.form.validate()
            }
            <<< ButtonRow("saveChangesButton") {
                $0.title = "Save Changes"
                $0.hidden = Condition.init(booleanLiteral: self.style != .view)
            }
            .onCellSelection { [weak self] (cell, row) in
                self?.form.validate()
            }
    }
    
    func buildPersonalInformationSection() {
        form +++ Section("Personal Information")
            <<< TextRow("name") {
                $0.title = "Name"
                $0.placeholder = "Your Name"
                $0.titlePercentage = 0.4
                $0.add(rule: RuleRequired())
                $0.value = user?.account.name
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
            }

            <<< DateRow("birthday"){
                $0.title = "Birthday"
                $0.add(rule: RuleRequired())
                $0.value = user?.personalData.birthday
            }

            <<< PhoneRow("phoneNumber") {
                $0.title = "Phone number"
                $0.placeholder = "Phone number"
                $0.titlePercentage = 0.4
                $0.value = user?.personalData.phoneNumber
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
            }

            <<< ActionSheetRow<String>("gender") {
                $0.title = "Gender"
                $0.options = ["Male", "Female", "Not specified"]
                $0.value = user?.personalData.gender ?? "Not specified"
            }
    }
    
    func buildOccupationSection() {
        form +++ Section("Occupation")
            <<< ActionSheetRow<String>("currentOccupation") {
                $0.title = "Current occupation"
                $0.options = ["Student", "Employee"]
                $0.value = (user?.personalData.company ?? "") == "" ? "Student" : "Company"
            }
            <<< TextRow("university") {
                $0.title = "University"
                $0.placeholder = "University"
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value! != "Student")
                })
                $0.value = user?.personalData.university
            }
            <<< TextRow("studyProgram") {
                $0.title = "Study Program"
                $0.placeholder = "Study Program"
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value! != "Student")
                })
                $0.value = user?.personalData.studyProgram
            }
            <<< TextRow("company") {
                $0.title = "Company"
                $0.placeholder = "Company"
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value != "Employee")
                })
                $0.value = user?.personalData.company
            }
    }
    
    func buildCredentialsSection() {
        form +++ Section("Credentials")

            <<< TextRow("country") {
                $0.title = "Country"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
                $0.value = user?.personalData.countryOfResidence
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            
            <<< EmailRow("email") {
                $0.title = "Email"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
                $0.value = user?.personalData.email
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .right
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            
            <<< AccountRow("username") {
                $0.title = "Username"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
                $0.hidden = Condition.init(booleanLiteral: self.style != .registration)
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
                cell.textLabel?.textAlignment = .left
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
    }
}
