//
//  AddNewCityViewController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit



class AddNewCityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var txtCityName: UITextField?
    @IBOutlet weak var txtWeatherConditions: UITextField?
    @IBOutlet weak var txtMinimumTemperature: UITextField?
    @IBOutlet weak var txtMaximumTemperature: UITextField?
    @IBOutlet weak var txtHumidity: UITextField?
    @IBOutlet weak var btnAddCity: UIButton?

    lazy var orderedTextFields = [
        self.txtCityName,
        self.txtWeatherConditions,
        self.txtMinimumTemperature,
        self.txtMaximumTemperature,
        self.txtHumidity
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Subscribe for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper methods

    // MARK: - Keyboard notification handling
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.scrollView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.scrollView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    // MARK: - UITextFieldDelegate Implementation
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        DispatchQueue.main.async {
            self.moveToTextField(after: textField)
        }
        
        return true
    }
    
    
    func moveToTextField(after: UITextField) {
        
        guard let textFieldIndex = self.orderedTextFields.firstIndex(of: after) else {
            // Do nothing this text field isn't part of this form
            return
        }
        
        let nextIdx = textFieldIndex + 1
        
        guard nextIdx < self.orderedTextFields.count else {
            // There is no next text field, we just dismiss the keyboard
            self.view.endEditing(true)
            return
        }
        
        self.orderedTextFields[nextIdx]?.becomeFirstResponder()
    }
    
    
    // MARK: - Actions
    
    @IBAction func onAddCityPressed(_ sender: Any) {
        // TODO: Implement me
    }
    

}
