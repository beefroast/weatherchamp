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
    
        enum Condition {
            case sunny
            case cloudy
            case rainy
            case hail
            case snow
            case storm
        }
        
        let name: String
        let condition: Condition
        let minTemperature: Int
        let maxTemperature: Int
        let humidity: Int
        
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
