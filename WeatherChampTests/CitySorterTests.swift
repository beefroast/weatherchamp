//
//  CitySorterTests.swift
//  WeatherChampTests
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest
@testable import WeatherChamp


class CitySorterTests: XCTestCase {

    
    fileprivate func cityWith(name: String) -> Model.City {
        return Model.City.init(name: name, condition: .acidRain, minTemperature: 0, maxTemperature: 0, humidity: 0)
    }
    
    fileprivate func cityWith(maxTemperature: Int) -> Model.City {
        return Model.City.init(name: "City", condition: .acidRain, minTemperature: 0, maxTemperature: maxTemperature, humidity: 0)
    }
    
    fileprivate func cityWith(minTemperature: Int) -> Model.City {
        return Model.City.init(name: "City", condition: .acidRain, minTemperature: minTemperature, maxTemperature: 0, humidity: 0)
    }

    // MARK: - Alphabetical sorting
    
    func testAlphabetical() {
 
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeAlphabetically(
            cityA: cityWith(name: "Alfonzo"),
            cityB: cityWith(name: "Pancakes")
        )
        
        XCTAssertTrue(orderedBefore)
    }
    
    func testReverseAlphabetical() {
        
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeAlphabetically(
            cityA: cityWith(name: "Pancakes"),
            cityB: cityWith(name: "Alfonzo")
        )
        
        XCTAssertFalse(orderedBefore)
    }
    
    func testAlphabeticalSame() {
        
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeAlphabetically(
            cityA: cityWith(name: "Alfonzo"),
            cityB: cityWith(name: "Alfonzo")
        )
        
        XCTAssertFalse(orderedBefore)
    }
    
    func testAlphabeticalCaseAgnostic() {
        
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeAlphabetically(
            cityA: cityWith(name: "alfonzo"),
            cityB: cityWith(name: "Alfonzo")
        )
        
        XCTAssertFalse(orderedBefore)
        
        let orderedBeforeInReverse = sorter.isOrderedBeforeAlphabetically(
            cityA: cityWith(name: "Alfonzo"),
            cityB: cityWith(name: "alfonzo")
        )
        
        XCTAssertFalse(orderedBeforeInReverse)
    }
    
    // MARK: - Maximum temperature
    
    func testMaxTemp() {
        
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeByMaxTemperature(
            cityA: cityWith(maxTemperature: 10),
            cityB: cityWith(maxTemperature: 0)
        )
        
        XCTAssertTrue(orderedBefore)
    }
    
    func testReverseMaxTemp() {
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeByMaxTemperature(
            cityA: cityWith(maxTemperature: 0),
            cityB: cityWith(maxTemperature: 10)
        )
            
        XCTAssertFalse(orderedBefore)
    }
    
    func testMaxTempSame() {
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeByMaxTemperature(
            cityA: cityWith(maxTemperature: 0),
            cityB: cityWith(maxTemperature: 0)
        )
        
        XCTAssertFalse(orderedBefore)
    }
    
    // MARK: - Minimum temperature sorting
    
    
    func testMinTemp() {
        
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeByMinTemperature(
            cityA: cityWith(minTemperature: 0),
            cityB: cityWith(minTemperature: 10)
        )
        
        XCTAssertTrue(orderedBefore)
    }
    
    func testReverseMinTemp() {
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeByMinTemperature(
            cityA: cityWith(minTemperature: 10),
            cityB: cityWith(minTemperature: 0)
        )
        
        XCTAssertFalse(orderedBefore)
    }
    
    func testSameMinTemp() {
        let sorter = CitySorter()
        
        let orderedBefore = sorter.isOrderedBeforeByMinTemperature(
            cityA: cityWith(minTemperature: 0),
            cityB: cityWith(minTemperature: 0)
        )
        
        XCTAssertFalse(orderedBefore)
    }
    

}
