//
//  TestTextFieldValidator.swift
//  WeatherChampTests
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


import XCTest
@testable import WeatherChamp

class TextFieldValidatorTests: XCTestCase {
    
    var validator: TextFieldValidator!
    var textField: UITextField!
    
    override func setUp() {
        self.validator = TextFieldValidator()
        self.textField = UITextField()
    }

    
    
    
    func testNilTextFieldErrors() {
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let name = validator.validateCityName(textField: nil) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(name)
    }
    
    func testCityNameValidationHappyPath() {
        
        let enteredName = "Chippendale"
        
        textField.text = enteredName
        
        let name = validator.validateCityName(textField: textField) { (error) -> (Void) in
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(enteredName, name)
    }
    
    func testCityNameValidationEmptyName() {
        
        let enteredName = ""
        
        textField.text = enteredName
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let name = validator.validateCityName(textField: textField) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(name)
    }
    
    func testNumericalInputValidationHappyPathZero() {
        
        textField.text = "0"
        
        let value = validator.validateNumeric(textField: textField, minimumValue: -10000, maximumValue: 10000) { (error) -> (Void) in
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(value, 0)
    }
    
    func testNumericalInputValidationHappyPathPositiveNumber() {
        
        textField.text = "12.34"
        
        let value = validator.validateNumeric(textField: textField, minimumValue: -10000, maximumValue: 10000) { (error) -> (Void) in
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(value, 1234)
    }
    
    func testNumericalInputValidationHappyPathNegativeNumber() {
        
        textField.text = "-12.34"
        
        let value = validator.validateNumeric(textField: textField, minimumValue: -10000, maximumValue: 10000) { (error) -> (Void) in
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        
        XCTAssertEqual(value, -1234)
    }
    
    func testNumericalInputValidationTooManyDecimalNumerals() {
        
        textField.text = "-12.3442"
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let value = validator.validateNumeric(textField: textField, minimumValue: -10000, maximumValue: 10000) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(value)
    }
    
    func testNumericalInputValidationNonNumericInput() {
        
        textField.text = "I like seagulls"
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let value = validator.validateNumeric(textField: textField, minimumValue: -10000, maximumValue: 10000) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(value)
    }
    
    func testNumericalInputValidationInvalidNumber() {
        
        textField.text = "-.24"
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let value = validator.validateNumeric(textField: textField, minimumValue: -10000, maximumValue: 10000) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(value)
    }
    
    func testNumericalInputValidationTooManyDecimals() {
        
        textField.text = "123.23.14"
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let value = validator.validateNumeric(textField: textField, minimumValue: -10000, maximumValue: 10000) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(value)
    }
    
    func testNumericalInputBelowMinimum() {
        
        textField.text = "-100.0"
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let value = validator.validateNumeric(textField: textField, minimumValue: 0, maximumValue: 10000) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(value)
    }
    
    func testNumericalInputAboveMaximum() {
        
        textField.text = "100000.23"
        
        let expectation = self.expectation(description: "Error callback is entered")
        
        let value = validator.validateNumeric(textField: textField, minimumValue: 0, maximumValue: 10000) { (error) -> (Void) in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNil(value)
    }

}
