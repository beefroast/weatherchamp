//
//  DocumentStorageController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation


class DocumentStorageController: StorageController {
    
    func save(city: Model.City) throws {
        // TODO: Save
    }
    
    func delete(city: Model.City) throws {
        // TODO: Delete
    }
    
    func getCities() throws -> [Model.City] {
        return [
            Model.City(
                name: "A Very Long City Name, And Some More Text Just To Be Sure",
                condition: .storm,
                minTemperature: 1234,
                maxTemperature: 2345,
                humidity: 3456
            )
        ]
    }
   
}
