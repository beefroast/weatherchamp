//
//  CityWeatherViewController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit

class CityWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentifier = "cityCell"
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - UITableViewDelegate/DataSource Implementation
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? CityTableViewCell else {
                return UITableViewCell()
        }
        
        // TODO: Apply data to cell
        
        return cell
    }
    

}
