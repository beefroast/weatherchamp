//
//  CityWeatherViewControllerTests.swift
//  WeatherChampTests
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest
@testable import WeatherChamp



class CityWeatherViewControllerTests: XCTestCase {

    var vc: CityWeatherViewController!

    
    override func setUp() {
        // Create the view controller and load it
        
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as? UINavigationController
        self.vc = nav?.viewControllers.first as? CityWeatherViewController
        self.vc.storage = DummyStorageController()
        
        UIApplication.shared.keyWindow!.rootViewController = vc

        // Force them to load
        let _ = nav?.view
        let _ = self.vc.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - UITableViewDelegate/DataSource Test Implementation

    func testNumberOfRows() {
        let rows = vc.tableView(vc.tableView!, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, 1)
    }

    func testCell() {
        let cell = vc.tableView(vc.tableView!, cellForRowAt: IndexPath.init(row: 0, section: 0)) as! CityTableViewCell
        
        XCTAssertEqual(cell.lblCityTitle?.text, "Test City")
        XCTAssertEqual(cell.lblWeatherType?.text, "Rainy")
        XCTAssertEqual(cell.lblMinimumTemp?.text, "-10.0°C")
        XCTAssertEqual(cell.lblMaximumTemp?.text, "12.34°C")
        XCTAssertEqual(cell.lblHumidity?.text, "50.30%")
    }
    


}




class DummyStorageController: StorageController {
    
    func save(city: Model.City) throws -> Model.City {
        // Do nothing
        return city
    }
    
    func delete(city: Model.City) throws {
        // Do nothing
    }
    
    func getCities() throws -> [Model.City] {
        return [
            Model.City(
                name: "Test City",
                condition: .rainy,
                minTemperature: -1000,
                maxTemperature: 1234,
                humidity: 5030
            )
        ]
    }
}
