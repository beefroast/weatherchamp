//
//  City.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


extension Model {
    
    class City {
        
        enum Condition: String, CaseIterable {
            case sunny
            case cloudy
            case rainy
            case hail
            case snow
            case storm
            case acidRain
        }
        
        let name: String
        let condition: Condition
        let minTemperature: Int     // Expressed as hundredths of a degree
        let maxTemperature: Int     // i.e. the value 2412 will indicate a temperature
        let humidity: Int           // of 24.12 etc.
        
        init(
            name: String,
            condition: Condition,
            minTemperature: Int,
            maxTemperature: Int,
            humidity: Int) {
            
            self.name = name
            self.condition = condition
            self.minTemperature = minTemperature
            self.maxTemperature = maxTemperature
            self.humidity = humidity
        }
        
        // Utility method for stringifiying temperature/humidity values
        static func displayableValueFrom(hundredths: Int) -> String {
            // We could optionally show less significant digits, but
            // let's be consistent for the time being.
            let fractionalPart = hundredths % 100
            let degrees = hundredths / 100
            return "\(degrees).\(abs(fractionalPart))"
        }
        
        static func displayableValueFrom(condition: Condition) -> String {
            switch condition {
            case .sunny: return "Sunny"
            case .cloudy: return "Cloudy"
            case .rainy: return "Rainy"
            case .hail: return "Hail"
            case .snow: return "Snow"
            case .storm: return "Stormy"
            case .acidRain: return "Acid Rain"
            }
        }
    }
}
