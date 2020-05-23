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
        
        moveIfAuthorized()
    }
    
    func moveIfAuthorized() {
        if (IdaoManager.shared.isAuthorized()) {
            let newViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
            self.addChild(newViewController!)
            self.view.addSubview(newViewController!.view)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        IdaoManager.shared.auth(username: usernameField.text ?? "", password: usernameField.text ?? "")
        
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


}

