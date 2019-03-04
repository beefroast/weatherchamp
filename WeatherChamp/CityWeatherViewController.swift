//
//  CityWeatherViewController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit

class CityWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddNewCityViewControllerDelegate {

    let cellIdentifier = "cityCell"
    
    @IBOutlet weak var tableView: UITableView?
    
    var cityList: [Model.City]? {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Temporary testing line
        self.cityList = [
            Model.City(
                name: "A Very Long City Name, And Some More Text Just To Be Sure",
                condition: .storm,
                minTemperature: 1234,
                maxTemperature: 2345,
                humidity: 3456
            )
        ]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddNewCityViewController {
            vc.delegate = self
        }
    }
    
    
    // MARK: - Helper methods
    
    func cityFor(indexPath: IndexPath) -> Model.City? {
        guard let list = self.cityList,
            indexPath.row < list.count else {
            return nil
        }
        return list[indexPath.row]
    }
    
    func weatherDescriptionFor(condition: Model.City.Condition) -> String {
        // TODO: Implement a nice description
        return "\(condition)"
    }
    
    func displayableValueFrom(hundredths: Int) -> String {
        // We could optionally show less significant digits, but
        // let's be consistent for the time being.
        let fractionalPart = hundredths % 100
        let degrees = hundredths / 100
        return "\(degrees).\(fractionalPart)"
    }
    
    
    // MARK: - UITableViewDelegate/DataSource Implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let cell = dequeuedCell as? CityTableViewCell,
            let city = self.cityFor(indexPath: indexPath) else {
                
                // Return an empty cell to avoid crashing here
                return UITableViewCell()
        }
        
        // TODO: This could be moved, it'll be fine here for now...
        cell.lblCityTitle?.text = city.name
        cell.lblWeatherType?.text = self.weatherDescriptionFor(condition: city.condition)
        cell.lblHumidity?.text = "\(self.displayableValueFrom(hundredths: city.humidity))%"
        cell.lblMinimumTemp?.text = "\(self.displayableValueFrom(hundredths: city.minTemperature))°"
        cell.lblMaximumTemp?.text = "\(self.displayableValueFrom(hundredths: city.maxTemperature))°"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // MARK: - AddNewCityViewControllerDelegate Implementation
    
    func addNewCity(vc: AddNewCityViewController, enteredCity: Model.City) {
        
        // TODO: Pass this along to our delegate so it can be saved
        
        self.cityList?.insert(enteredCity, at: 0)
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    

}
