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
    
    //св-во которое хранит ключ
    lazy var weatherManager = APIWeatherManager(apiKey: "d7195ca6bf988f63b58b61b868560120")
    let coordinates = Coordinates(latitude: 55.679768, longitude: 37.545419)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Получаем реальные данные с сайта. Работает в фоновом режиме
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates, competionHandler: { (result) in
            switch result {
                //передаем экземпляр погоды которую мы получили
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            default: break
            }
        })
    }
    
    //метод для загрузки новых данных
    func updateUIWith(currentWeather: CurrentWeather) {
        //Look it in extension in CurrentWeather.swift
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.humidityLabel.text = currentWeather.humidityString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = currentWeather.appearentTemperatureString
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        
        
    }
    
}



