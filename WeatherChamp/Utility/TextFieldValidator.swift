//
//  TextFieldValidator.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation
import UIKit

class TextFieldValidator {
    
    enum InputError: Error {
        case required
        case invalidNumber
    }
    
    private func validateExists(textField: UITextField?) throws -> String {
        guard let text = textField?.text else {
            throw InputError.required
        }
        return text
    }
    
    private func validateNotEmpty(text: String) throws -> String {
        guard text.count > 0 else {
            throw InputError.required
        }
        return text
    }

    private func validateNumber(text: String) throws -> Int {
        
        // Regex matches numerical entry of an optional minus sign,
        // followed by some amount of digits, optionally followed
        // by a period and then 1 or two digits
        let regex = "^-?[0-9]+(\\.[0-9]{1,2})?$"
        
        // Check to see if it's valid input
        guard text.range(of: regex, options: .regularExpression) != nil else {
            throw InputError.invalidNumber
        }
        
        let components = text.components(separatedBy: ".")
        let result: Int?
        
        switch components.count {
        
            case 1:
                result = Int(components[0]).map({ $0 * 100 })

            case 2:
                if let x = Int(components[0]), let y = Int(components[1]) {
                        result = x * 100 + y
                } else {
                    result = nil
                }
            
            default:
                result = nil
        }
        
        guard let number = result else {
            throw InputError.invalidNumber
        }
        
        return number
    }
    
    
    func validateCityName(textField: UITextField, onError: ((Error) -> (Void))) -> String? {
        do {
            let text = try self.validateExists(textField: textField)
            return try validateNotEmpty(text: text)
        } catch (let error) {
            onError(error)
            return nil
        }
    }
    
    func validateTemperature(textField: UITextField, onError: ((Error) -> (Void))) -> String? {
        do {
            let text = try self.validateExists(textField: textField)
            return try validateNotEmpty(text: text)
        } catch (let error) {
            onError(error)
            return nil
        }
    }
    
    
    
    
}
