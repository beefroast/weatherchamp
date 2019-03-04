//
//  AddNewCityViewController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit


protocol AddNewCityViewControllerDelegate: AnyObject {
    func addNewCity(vc: AddNewCityViewController, enteredCity: Model.City)
}

class AddNewCityViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: AddNewCityViewControllerDelegate? = nil
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var txtCityName: UITextField?
    @IBOutlet weak var txtWeatherConditions: UITextField?
    @IBOutlet weak var txtMinimumTemperature: UITextField?
    @IBOutlet weak var txtMaximumTemperature: UITextField?
    @IBOutlet weak var txtHumidity: UITextField?
    @IBOutlet weak var btnAddCity: UIButton?

    // MARK: - Properties
    
    lazy var orderedTextFields = [
        self.txtCityName,
        self.txtWeatherConditions,
        self.txtMinimumTemperature,
        self.txtMaximumTemperature,
        self.txtHumidity
    ]
    
    var selectedWeatherCondition: Model.City.Condition? = nil {
        didSet {
            // TODO: This could be a bit better
            self.txtWeatherConditions?.text = self.selectedWeatherCondition.map({ "\($0)" })
        }
    }

    
    // MARK: - UIViewControllerLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Subscribe for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set up the custom pickers for the inputs
        self.setupConditionsPicker()
        self.selectedWeatherCondition = Model.City.Condition.allCases.first
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper methods
    
    func setupConditionsPicker() {
        
        let picker = UIPickerView(frame: CGRect.zero)
        
        picker.delegate = self
        picker.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        toolbar.sizeToFit()
        
        let nextButton = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(onToolbarNextPressed(sender:))
        )
        
        toolbar.items = [nextButton]
        
        self.txtWeatherConditions?.inputView = picker
        self.txtWeatherConditions?.inputAccessoryView = toolbar
    }
    
    @objc func onToolbarNextPressed(sender: Any?) -> Void {
        
        // Find the first responder
        guard let firstResponder = self.orderedTextFields
            .compactMap({ return $0 })  // Filter out any possible nil textfields from our list
            .first(where: { $0.isFirstResponder }) // Grab the first responder
            else {
                // Do nothing
                return
        }
        
        _ = self.textFieldShouldReturn(firstResponder)
    }
    
    // MARK: - UIPickerViewDelegate/DataSource Implementation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Model.City.Condition.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Model.City.Condition.allCases[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedWeatherCondition = Model.City.Condition.allCases[row]
    }

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
        
        // TODO: Validate the input...
        
        let enteredCity = Model.City.init(
            name: self.txtCityName?.text ?? "Unnamned",
            condition: self.selectedWeatherCondition!,
            minTemperature: 1234,
            maxTemperature: 2345,
            humidity: 3456
        )
        
        self.delegate?.addNewCity(vc: self, enteredCity: enteredCity)
    }
    

}
