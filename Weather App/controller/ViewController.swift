//
//  ViewController.swift
//  Weather App
//
//  Created by Piotr Chlapinski on 13/07/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var refreshLabel: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    var weatherForCityViewModel: WeatherForCityViewModel = WeatherForCityViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherForCityViewModel.getCurrentWeather(cityName: "")
    }

    @IBAction func refresh(_ sender: Any) {
        guard weatherForCityViewModel.weathers.count != 0 else {
            return
        }
//        tempLabel.text = "Temp: \(weatherForCityViewModel.weathers[0].weather[0].currentTemperature)"
    }
    
}

