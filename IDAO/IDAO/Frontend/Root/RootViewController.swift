//
//  RootViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 17.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if IdaoManager.shared.isAuthorized() {
            let mainViewController = UIStoryboard(name: "Main", bundle: .main).instantiateInitialViewController()
            self.parent?.present(mainViewController!, animated: false)
        } else {
            let mainViewController = UIStoryboard(name: "Login", bundle: .main).instantiateInitialViewController()
            self.parent?.present(mainViewController!, animated: false)
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
