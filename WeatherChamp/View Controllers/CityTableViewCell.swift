//
//  CityTableViewCell.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 4/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    @IBOutlet weak var imgWeatherType: UIImageView?
    @IBOutlet weak var lblCityTitle: UILabel?
    @IBOutlet weak var lblWeatherType: UILabel?
    @IBOutlet weak var lblMinimumTemp: UILabel?
    @IBOutlet weak var lblMaximumTemp: UILabel?
    @IBOutlet weak var lblHumidity: UILabel?
}
