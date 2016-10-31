//
//  ViewController.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 29/10/2016.
//  Copyright © 2016 Богдан Костюченко. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icon = WeatherIconManager.Rain.image
        let currentWeather = CurrentWeather(temperature: 10, appearentTemperature: 5, humidity: 20, pressure: 750, icon: icon)
        updateUIWith(currentWeather: currentWeather)
        
        //Unsafe code:
//        let urlString = "https://api.darksky.net/forecast/d7195ca6bf988f63b58b61b868560120/37.8267,-122.4233"
//        let baseURL = URL(string: "https://api.darksky.net/forecast/d7195ca6bf988f63b58b61b868560120/")
//        let fullURL = URL(string: "37.8267,-122.4233", relativeTo: baseURL)
//        
//        let sessionConfiguration = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfiguration)
//        let reqest = URLRequest(url: fullURL!)
        //получает данные
//        let dataTask = session.dataTask(with: fullURL!) { (data, response, error) in
//            
//        }
//        dataTask.resume()
    }
    
    func updateUIWith(currentWeather: CurrentWeather) {
        self.imageView.image = currentWeather.icon
        //Look at an extension in CurrentWeather.swift
        self.pressureLabel.text = currentWeather.pressureString
        self.humidityLabel.text = currentWeather.humidityString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = currentWeather.appearentTemperatureString
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
    }
    
}



