//
//  ViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 21.10.2019.
//  Copyright © 2019 Ivan Lebedev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var mainLoginView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        signInButton.layer.cornerRadius = 8
        signUpButton.layer.cornerRadius = 8
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        mainLoginView.layer.cornerRadius = 12
        self.addDoneButtonOnKeyboard()
        
        moveIfAuthorized()
    }
    
    func moveIfAuthorized() {
        if (IdaoManager.shared.isAuthorized()) {
            let mainViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
            self.present(mainViewController!, animated: true)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        IdaoManager.shared.auth(username: usernameField.text ?? "", password: passwordField.text ?? "")
        
        if (IdaoManager.shared.isAuthorized()) {
            moveIfAuthorized()
        } else {
            let alert = UIAlertController(title: "Wrong credentials", message: "Wrong username or password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let newViewController = PersonalDataViewController()
        newViewController.setStyle(style: .registration)
        let newNavController = UINavigationController(rootViewController: newViewController)
        self.navigationController?.present(newNavController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.usernameField.inputAccessoryView = doneToolbar
        self.passwordField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        self.usernameField.inputAccessoryView?.resignFirstResponder()
        self.passwordField.inputAccessoryView?.resignFirstResponder()
    }


}

