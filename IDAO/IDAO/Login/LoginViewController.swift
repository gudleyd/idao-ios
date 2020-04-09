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
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let newViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
        self.addChild(newViewController!)
        self.view.addSubview(newViewController!.view)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let newViewController = RegistrationViewController()
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

