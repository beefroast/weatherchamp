//
//  StorageController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation



protocol StorageController {
    
    // These methods could be upgraded to return Promises or handle
    // asynchronous cases if needed, but this will do for now.
    
    func save(city: Model.City) throws -> Model.City
    func delete(city: Model.City) throws
    func getCities() throws -> [Model.City]
}
