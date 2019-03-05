//
//  CitySorter.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


class CitySorter {
    
    func isOrderedBeforeAlphabetically(cityA: Model.City, cityB: Model.City) -> Bool {
        // Perform lexographical compare
        return cityA.name.lowercased() < cityB.name.lowercased()
    }
    
    func isOrderedBeforeByMinTemperature(cityA: Model.City, cityB: Model.City) -> Bool {
        // Smaller temperatures should appear at the start of the list
        return cityA.minTemperature < cityB.minTemperature
    }

    func isOrderedBeforeByMaxTemperature(cityA: Model.City, cityB: Model.City) -> Bool {
        // Larger temperatures should appear at the start of the list
        return cityA.maxTemperature > cityB.maxTemperature
    }
}

