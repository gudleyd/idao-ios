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
            <<< TextRow("firstName") {
                $0.placeholder = "First name"
                $0.titlePercentage = 0.4
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
            }
            
            <<< TextRow("lastName") {
                $0.placeholder = "Last name"
                $0.titlePercentage = 0.4
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
            }

            <<< DateRow("birthday"){
                $0.title = "Birthday"
                $0.add(rule: RuleRequired())
            }

            <<< PhoneRow("phoneNumber") {
                $0.title = "Phone number"
                $0.placeholder = "Phone number"
                $0.titlePercentage = 0.4
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
            }

            <<< ActionSheetRow<String>("gender") {
                $0.title = "Gender"
                $0.options = ["Male", "Female", "Not specified"]
                $0.value = "Not specified"
            }
    }
    
    func buildOccupationSection() {
        form +++ Section("Occupation")
            <<< ActionSheetRow<String>("currentOccupation") {
                $0.title = "Current occupation"
                $0.options = ["Student", "Employee"]
                $0.value = "Student"
            }
            <<< TextRow("university") {
                $0.placeholder = "University"
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow<String>)?.value! == "Student")
                })
            }
            <<< TextRow("studyProgram") {
                $0.placeholder = "Study program"
                $0.hidden = Condition.function(["currentOccupation"], { form in
                    return ((form.rowBy(tag: "currentOccupation") as? ActionSheetRow)?.value! == "Student")
                })
            }
    }
    
    func buildCredentialsSection() {
        form +++ Section("Credentials")

            <<< TextRow("country") {
                $0.title = "Country"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
                cell.textLabel?.textAlignment = .left
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            
            <<< EmailRow("email") {
                $0.title = "Email"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
                cell.textLabel?.textAlignment = .left
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            
            <<< AccountRow("username") {
                $0.title = "Username"
                $0.titlePercentage = 0.3
                $0.add(rule: RuleRequired())
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
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
                
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
            }
            .cellUpdate { cell, row in
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
