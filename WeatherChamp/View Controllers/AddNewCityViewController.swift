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
    
    lazy var validator = TextFieldValidator()    // This could be injected
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView?
    
    @IBOutlet weak var txtCityName: UITextField?
    @IBOutlet weak var txtWeatherConditions: UITextField?
    @IBOutlet weak var txtMinimumTemperature: UITextField?
    @IBOutlet weak var txtMaximumTemperature: UITextField?
    @IBOutlet weak var txtHumidity: UITextField?
    @IBOutlet weak var btnAddCity: UIButton?
    
    @IBOutlet weak var lblCityNameError: UILabel?
    @IBOutlet weak var lblWeatherConditionsError: UILabel?
    @IBOutlet weak var lblMinimumTemperatureError: UILabel?
    @IBOutlet weak var lblMaximumTemperatureError: UILabel?
    @IBOutlet weak var lblHumidityError: UILabel?
    

    // MARK: - Properties
    
    lazy var orderedTextFields = [
        self.txtCityName,
        self.txtWeatherConditions,
        self.txtMinimumTemperature,
        self.txtMaximumTemperature,
        self.txtHumidity
    ]
    
    lazy var orderedErrorFields = [
        self.lblCityNameError,
        self.lblWeatherConditionsError,
        self.lblMinimumTemperatureError,
        self.lblMaximumTemperatureError,
        self.lblHumidityError,
    ]
    
    var selectedWeatherCondition: Model.City.Condition? = nil {
        didSet {
            self.txtWeatherConditions?.text = selectedWeatherCondition.map({ (condition) -> String in
                Model.City.displayableValueFrom(condition: condition)
            })
        }
    }
    
    var scrollViewBottomInset: CGFloat = 0

    
    // MARK: - UIViewControllerLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Subscribe for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set up the custom pickers for the conditions input
        self.setupConditionsPicker()
        self.selectedWeatherCondition = Model.City.Condition.allCases.first
        
        // Add toolbars to condition and numeric inputs
        [
            self.txtWeatherConditions,
            self.txtMinimumTemperature,
            self.txtMaximumTemperature,
            self.txtHumidity
        ].compactMap({ return $0 }).forEach { (textField) in
            self.addToolbarWithNextButtonTo(textField: textField)
        }
        
        // Remember what the default scroll view bottom inset is
        self.scrollViewBottomInset = self.scrollView?.contentInset.bottom ?? 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper methods
    
    func setupConditionsPicker() {
        
        let picker = UIPickerView(frame: CGRect.zero)
        
        picker.delegate = self
        picker.dataSource = self
        
        self.txtWeatherConditions?.inputView = picker
    }
    
    func addToolbarWithNextButtonTo(textField: UITextField) {
        
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        let nextButton = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(onToolbarNextPressed(sender:))
        )
        
        toolbar.items = [nextButton]
        
        toolbar.sizeToFit()
        
        textField.inputAccessoryView = toolbar
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
        let condition = Model.City.Condition.allCases[row]
        return Model.City.displayableValueFrom(condition: condition)
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
        self.scrollView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: scrollViewBottomInset, right: 0)
    }
    
    // MARK: - UITextFieldDelegate Implementation
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Hide the error label
        guard let idx = self.orderedTextFields.firstIndex(where: { $0 === textField }) else { return }
        self.orderedErrorFields[idx]?.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case self.txtCityName: _ = self.validateCityName()
        case self.txtWeatherConditions: break
        case self.txtMinimumTemperature: _ = self.validateMinimumTemperature()
        case self.txtMaximumTemperature: _ = self.validateMaximumTemperature()
        case self.txtHumidity: _ = self.validateHumidity()
        default: break
        }
    }
    
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
            // There is no next text field so we just resign first responder
            after.resignFirstResponder()
            return
        }
        
        self.orderedTextFields[nextIdx]?.becomeFirstResponder()
    }
    
    
    // MARK: - Actions

    
    @IBAction func onAddCityPressed(_ sender: Any) {
        
        self.view.endEditing(true)
        
        // Validate that the input has been entered correctly.
        
        let mCityName = validateCityName()
        let mCondition = self.selectedWeatherCondition
        let mMinTemp = self.validateMinimumTemperature()
        let mMaxTemp = self.validateMaximumTemperature()
        let mHumidity = self.validateHumidity()
        
        if let maxTemp = mMaxTemp, let minTemp = mMinTemp {
            // Double check that the maximum temperature is greater than the minimum temperature
            guard maxTemp >= minTemp else {
                self.lblMinimumTemperatureError?.text = "Minimum temperature must be less than or equal to maximum temperature."
                self.lblMinimumTemperatureError?.isHidden = false
                return
            }
        }
        
        // Ensure that we have all validated inputs
        
        guard let cityName = mCityName,
            let condition = mCondition,
            let minTemp = mMinTemp,
            let maxTemp = mMaxTemp,
            let humidity = mHumidity else {
                return
        }
  
        
        let enteredCity = Model.City.init(
            name: cityName,
            condition: condition,
            minTemperature: minTemp,
            maxTemperature: maxTemp,
            humidity: humidity
        )
        
        self.delegate?.addNewCity(vc: self, enteredCity: enteredCity)
    }
    
    // MARK: - Validation
    
    func validateCityName() -> String? {
        return self.validator.validateCityName(
            textField: self.txtCityName,
            onError: validationErrorHandlerWith(errorLabel: self.lblCityNameError)
        )
    }
    
    func validateMinimumTemperature() -> Int? {
        return self.validator.validateNumeric(
            textField: self.txtMinimumTemperature,
            minimumValue: -27315,
            maximumValue: 10000,
            onError: validationErrorHandlerWith(errorLabel: self.lblMinimumTemperatureError)
        )
    }
    
    func validateMaximumTemperature() -> Int? {
        return self.validator.validateNumeric(
            textField: self.txtMaximumTemperature,
            minimumValue: -27315,
            maximumValue: 10000,
            onError: validationErrorHandlerWith(errorLabel: self.lblMaximumTemperatureError)
        )
    }
    
    func validateHumidity() -> Int? {
        return self.validator.validateNumeric(
            textField: self.txtHumidity,
            minimumValue: 0,
            maximumValue: 20000,
            onError: validationErrorHandlerWith(errorLabel: self.lblHumidityError)
        )
    }
    
    func validationErrorHandlerWith(errorLabel: UILabel?) -> ((Error) -> (Void)) {
        return { (error) in
            errorLabel?.text = self.labelTextFor(error: error)
            errorLabel?.isHidden = false
        }
    }
    
    func labelTextFor(error: Error) -> String {
        guard let err = error as? TextFieldValidator.InputError else {
            return "An unknown error has occured"
        }
        switch err {
        case .required:
            return "Required"
        case .invalidNumber:
            return "Please enter a valid number"
        case .valueExceedsMinimum(let min):
            return "Value must be greater than or equal to \(Model.City.displayableValueFrom(hundredths: min))"
        case .valueExceedsMaximum(let max):
            return "Value must be less than or equal to \(Model.City.displayableValueFrom(hundredths: max))"
        }
    }
    

}
