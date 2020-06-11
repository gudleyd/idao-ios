//
//  ProfileViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 22.10.2019.
//  Copyright © 2019 Ivan Lebedev. All rights reserved.
//

import UIKit


class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var profileCardView: UIView!
    
    @IBOutlet weak var profileCell: UITableViewCell!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IdaoStorage.appUser.subscribe(AppUserStorage.StorageObserver(delegate: self))
        
        IdaoStorage.appUser.get { [weak self] user in
           if user.count > 0 {
               DispatchQueue.main.async {
                   self?.user = user[0]
                   self?.updateInfo()
               }
           }
        }
        
        self.shadowView.layer.cornerRadius = 8
        self.shadowView.layer.shadowOffset = CGSize(width: 5, height: 3)
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowRadius = 3
        self.shadowView.layer.shadowOpacity = 0.1
        
        self.profileCardView.layer.cornerRadius = 8
        self.profileCardView.clipsToBounds = true
    
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.minimumScaleFactor = 0.2
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        IdaoManager.shared.logOut()
        let loginViewController = UIStoryboard(name: "Login", bundle: .main).instantiateInitialViewController()
        self.present(loginViewController!, animated: true)
    }
    
    @IBAction func editPersonalInfoButtonTapped(_ sender: Any) {
        let personalDataController = PersonalDataViewController()
        personalDataController.setStyle(style: .view)
        personalDataController.setUser(user: self.user)
        let personalDataNavController = UINavigationController(rootViewController: personalDataController)
        self.present(personalDataNavController, animated: true, completion: nil)
    }
    
    func updateInfo() {
        if let account = user?.account {
            self.nameLabel.text = account.name
            self.usernameLabel.text = "@\(account.username)"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: StorageObserverDelegate {
    
    func update(_ sender: Any?, _ data: Any?) {
        DispatchQueue.main.async { [weak self] in
            guard let user = data as? [User] else { return }
            if user.count > 0 {
                self?.user = user[0]
                self?.updateInfo()
            }
        }
    }
}
