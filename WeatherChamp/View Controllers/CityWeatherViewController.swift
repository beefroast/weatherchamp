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
    
    var cityList: SortedList<Model.City>? {
        didSet { self.tableView?.reloadData() }
    }
    
    // NOTE: This could be injected, for now we just instantiate it here
    lazy var storage: StorageController = DocumentStorageController()
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            // Get the cities from storage
            let unsortedCities = try self.storage.getCities()
            self.cityList = SortedList.init(elements: unsortedCities, orderedBefore: { (a, b) -> Bool in
                CitySorter().isOrderedBeforeAlphabetically(cityA: a, cityB: b)
            })
        } catch (let error) {
            // TODO: We could handle displaying an error to the user
        }
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
        cell.lblWeatherType?.text = Model.City.displayableValueFrom(condition: city.condition)
        cell.lblHumidity?.text = "\(Model.City.displayableValueFrom(hundredths: city.humidity))%"
        cell.lblMinimumTemp?.text = "\(Model.City.displayableValueFrom(hundredths: city.minTemperature))°C"
        cell.lblMaximumTemp?.text = "\(Model.City.displayableValueFrom(hundredths: city.maxTemperature))°C"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let city = self.cityFor(indexPath: indexPath) else { return }
            
            let alertCon = UIAlertController(
                title: "Confirm",
                message: "Are you sure you want to delete \(city.name)?",
                preferredStyle: UIAlertController.Style.alert
            )
            
            alertCon.popoverPresentationController?.sourceRect = tableView.rectForRow(at: indexPath)
            alertCon.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
            
            alertCon.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in
                // Do nothing
            }))
            
            alertCon.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { (_) in
                
                do {
                    try self.storage.delete(city: city)
                    self.cityList?.remove(index: indexPath.row)
                    self.tableView?.deleteRows(at: [indexPath], with: .none)
                } catch (_) {
                    // TODO: Handle problem deleting in here...
                }
            }))
            
            self.present(alertCon, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - AddNewCityViewControllerDelegate Implementation
    
    func addNewCity(vc: AddNewCityViewController, enteredCity: Model.City) {
        
        do {
            let newCity = try self.storage.save(city: enteredCity)
            guard let index = self.cityList?.insert(element: newCity) else { return }
            let indexPath = IndexPath.init(row: index, section: 0)
            self.tableView?.insertRows(at: [indexPath], with: .none)
            self.tableView?.scrollToRow(at: indexPath, at: .middle, animated: true)
        } catch (_) {
            // Do nothing
        }
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    

    // MARK: - Actions
    
    @IBAction func onSortPressed(_ sender: UIBarButtonItem) {
        
        let alertCon = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        alertCon.addAction(UIAlertAction(
            title: "City Name",
            style: .default,
            handler: { (_) in
                self.cityList = self.cityList?.withOrderedBefore(orderedBefore: { (a, b) -> Bool in
                    CitySorter().isOrderedBeforeAlphabetically(cityA: a, cityB: b)
                })
        }))
        
        alertCon.addAction(UIAlertAction(
            title: "Max Temperature",
            style: .default,
            handler: { (_) in
                self.cityList = self.cityList?.withOrderedBefore(orderedBefore: { (a, b) -> Bool in
                    CitySorter().isOrderedBeforeByMaxTemperature(cityA: a, cityB: b)
                })
                
        }))
        
        alertCon.addAction(UIAlertAction(
            title: "Min Temperature",
            style: .default,
            handler: { (_) in
                self.cityList = self.cityList?.withOrderedBefore(orderedBefore: { (a, b) -> Bool in
                    CitySorter().isOrderedBeforeByMinTemperature(cityA: a, cityB: b)
                })
        }))
    
        alertCon.popoverPresentationController?.barButtonItem = sender
        
        alertCon.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertCon, animated: true, completion: nil)
    }
}
