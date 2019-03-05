//
//  DocumentStorageControllerTests.swift
//  WeatherChampTests
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest
@testable import WeatherChamp

class DocumentStorageControllerTests: XCTestCase {

    
    // NOTE: This could be generised to test the Protocol StorageController
    // instead of DocumentStorageController, and then those tests could be
    // applied to DocumentStorageController.
    
    let filename = "test_cities.json"
    var storage: DocumentStorageController!
    
    
    override func setUp() {
        self.storage = DocumentStorageController.init(fileName: filename)
        do {
            let filePath = try storage.getFilePath()
            try FileManager.default.removeItem(at: filePath)
        } catch (_) {
            // Ignore the error
        }
    }

    override func tearDown() {
        do {
            let filePath = try storage.getFilePath()
            try FileManager.default.removeItem(at: filePath)
        } catch (_) {
           // Ignore errors removing test cities here
        }
    }
    
    

    func testGetNoCities() {
        
        do {
            let cities = try storage.getCities()
            XCTAssertEqual(0, cities.count)
            
        } catch (let error) {
            XCTFail("Unexpected error: \(error)")
        }
        
    }
    
    func testSaveACity() {
        
        do {
            let city = Model.City(
                name: "Zanzibar",
                condition: .cloudy,
                minTemperature: 0,
                maxTemperature: 100,
                humidity: 50
            )
            
            try self.storage.save(city: city)
            
            let cities = try storage.getCities()
            
            XCTAssertEqual(cities.count, 1)
            
            let savedCity = cities[0]
            
            XCTAssertEqual(savedCity.name, city.name)
            XCTAssertEqual(savedCity.condition, city.condition)
            XCTAssertEqual(savedCity.minTemperature, city.minTemperature)
            XCTAssertEqual(savedCity.maxTemperature, city.maxTemperature)
            XCTAssertEqual(savedCity.humidity, city.humidity)
            
        } catch (let error) {
            XCTFail("Unexpected error: \(error)")
        }
        
    }
    
    func testSaveACityPersisting() {
        
        do {
            let city = Model.City(
                name: "Zanzibar",
                condition: .cloudy,
                minTemperature: 0,
                maxTemperature: 100,
                humidity: 50
            )
            
            try self.storage.save(city: city)
            
            // Make a new storage controller, so the other deallocs
            self.storage = DocumentStorageController.init(fileName: filename)
            
            let cities = try storage.getCities()
            
            XCTAssertEqual(cities.count, 1)
            
            let savedCity = cities[0]
            
            XCTAssertEqual(savedCity.name, city.name)
            XCTAssertEqual(savedCity.condition, city.condition)
            XCTAssertEqual(savedCity.minTemperature, city.minTemperature)
            XCTAssertEqual(savedCity.maxTemperature, city.maxTemperature)
            XCTAssertEqual(savedCity.humidity, city.humidity)
            
        } catch (let error) {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDeletingCity() {
        
        do {
            let city = Model.City(
                name: "Zanzibar",
                condition: .cloudy,
                minTemperature: 0,
                maxTemperature: 100,
                humidity: 50
            )
            
            let savedCity = try self.storage.save(city: city)
        
            try self.storage.delete(city: savedCity)
            
            let cities = try storage.getCities()
            
            XCTAssertEqual(cities.count, 0)
            
        } catch (let error) {
            XCTFail("Unexpected error: \(error)")
        }
        
    }
    
  


}
