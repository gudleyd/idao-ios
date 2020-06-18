//
//  AgreementViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 18.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

class AgreementViewController: UIViewController {

    @IBOutlet weak var agreementTextView: UITextView!
    @IBOutlet weak var agreeButton: UIButton!
    
    var onAgree: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancel))
        
        self.agreeButton.isEnabled = false
        self.agreeButton.layer.cornerRadius = 8
    }
    
    func loadAgreement(attributedStringWithRtf: NSAttributedString) {
        self.agreementTextView.attributedText = attributedStringWithRtf
        self.agreeButton.isEnabled = true
    }
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onAgree?()
        }
    }
    
    @objc
    func cancel() {
        self.dismiss(animated: true)
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
