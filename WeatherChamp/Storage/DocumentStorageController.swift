//
//  DocumentStorageController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation




class DocumentStorageController: StorageController {    
    
    let fileName: String
    fileprivate var cityList: [EncodableCity] = []
    lazy var fileManager = FileManager.default
    
    
    enum DocumentError: Error {
        case couldNotFindDocumentsPath
    }
    
    init(fileName: String = "cities.json") {
        
        self.fileName = fileName
        
        do {
            // Attempt to read the cities from storage
            try self.readAllCities()
        } catch (_) {
            // Do nothing, we can't read the cities so we
            // just use an empty list for now...
        }
    }
    
    // MARK: - Private methods
    
    func getFilePath() throws -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsDirectory = paths.first else {
            throw DocumentError.couldNotFindDocumentsPath
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func writeAllCities() throws -> Void {
        let path = try getFilePath()
        let data = try JSONEncoder().encode(self.cityList)
        try data.write(to: path)
    }
    
    func readAllCities() throws -> Void {
        let path = try getFilePath()
        let data = try Data.init(contentsOf: path, options: [])
        let cities = try JSONDecoder().decode(Array<EncodableCity>.self, from: data)
        self.cityList = cities
    }
    
    // MARK: - StorageController Implementation
    
    func save(city: Model.City) throws -> Model.City {
        
        // Create an encodable version of the city
        // and append it to the list
        let encodable = EncodableCity.from(city: city)
        cityList.append(encodable)
        
        // Write
        try self.writeAllCities()
        
        // Return the encodable city
        return encodable
    }
    
    func delete(city: Model.City) throws {
        
        // Remove the city from the list
        self.cityList.removeAll { (savedCity) -> Bool in
            
            // This is very cheeky, I know that all the saved cities in the list
            // will be 'EncodableCities', so I can do this...
            // Should probably move towards using UUIDs to identifier cities.
            savedCity === city
        }
        
        // Write
        try self.writeAllCities()
    }
    
    func getCities() throws -> [Model.City] {
        return cityList
    }
}

class EncodableCity: Model.City, Encodable, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case name
        case condition
        case minTemperature
        case maxTemperature
        case humidity
    }
    
    static func from(city: Model.City) -> EncodableCity {
        return EncodableCity(
            name: city.name,
            condition: city.condition,
            minTemperature: city.minTemperature,
            maxTemperature: city.maxTemperature,
            humidity: city.humidity
        )
    }
    
    override init(
        name: String,
        condition: Condition,
        minTemperature: Int,
        maxTemperature: Int,
        humidity: Int) {
        
        super.init(
            name: name,
            condition: condition,
            minTemperature: minTemperature,
            maxTemperature: maxTemperature,
            humidity: humidity
        )
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try values.decode(String.self, forKey: .name)
        let minTemperature = try values.decode(Int.self, forKey: .minTemperature)
        let maxTemperature = try values.decode(Int.self, forKey: .maxTemperature)
        let humidity = try values.decode(Int.self, forKey: .humidity)
        let conditionString = try values.decode(String.self, forKey: .condition)
        guard let condition = Condition(rawValue: conditionString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .condition,
                in: values,
                debugDescription: "Invalid weather condition: \(conditionString)"
            )
        }
        
        super.init(
            name: name,
            condition: condition,
            minTemperature: minTemperature,
            maxTemperature: maxTemperature,
            humidity: humidity
        )
    }
   
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.name, forKey: .name)
        try container.encode(self.minTemperature, forKey: .minTemperature)
        try container.encode(self.maxTemperature, forKey: .maxTemperature)
        try container.encode(self.humidity, forKey: .humidity)
        try container.encode(self.condition.rawValue, forKey: .condition)
    }
}
