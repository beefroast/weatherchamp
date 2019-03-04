//
//  AddNewCityViewController.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit

class AddNewCityViewController: UIViewController {

    @IBOutlet weak var txtCityName: UITextField?
    @IBOutlet weak var txtWeatherConditions: UITextField?
    @IBOutlet weak var txtMinimumTemperature: UITextField?
    @IBOutlet weak var txtMaximumTemperature: UITextField?
    @IBOutlet weak var txtHumidity: UITextField?
    @IBOutlet weak var btnAddCity: UIButton?
    @IBOutlet weak var constraintScrollContainerToBottom: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAddCityPressed(_ sender: Any) {
        // TODO: Implement me
    }
    

}
