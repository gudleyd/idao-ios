//
//  ActionSheetStylePickerViewController.swift
//  IDAO
//
//  Created by Ivan Lebedev on 06.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit

protocol ASSPickerDelegate: class {
    func valuePicked(value: (Int, String, Any?))
}

class ActionSheetStylePickerViewController: UIViewController {
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    private var options = [String]()
    private var data: [Any]?
    weak public var delegate: ASSPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mainView.layer.cornerRadius = 8
        self.mainView.layer.shadowOffset = CGSize(width: 5, height: 3)
        self.mainView.layer.shadowColor = UIColor.black.cgColor
        self.mainView.layer.shadowRadius = 3
        self.mainView.layer.shadowOpacity = 0.1
        
        self.mainView.layer.cornerRadius = 8
        self.buttonsView.layer.cornerRadius = 8
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let originalMainViewTransform = self.mainView.transform
        self.mainView.transform = originalMainViewTransform.translatedBy(x: 0.0, y: 300.0)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.mainView.transform = originalMainViewTransform
        })
    }
    
    
    public func setOptions(_ options: [String]) {
        self.options = options
    }
    
    public func setData(_ data: [Any]) {
        self.data = data
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        if self.options.count > 0 {
            let selectedRow = self.picker.selectedRow(inComponent: 0)
            self.delegate?.valuePicked(value: (selectedRow, self.options[selectedRow], self.data?[selectedRow]))
        }
        self.dismiss(animated: true, completion: nil)
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


extension ActionSheetStylePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.options[row]
    }
}
