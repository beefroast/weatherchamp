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
        
        enum Condition: String, Encodable, CaseIterable {
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
    }
}
