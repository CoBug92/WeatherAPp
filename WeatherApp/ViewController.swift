//
//  ViewController.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 29/10/2016.
//  Copyright © 2016 Богдан Костюченко. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //св-во которое хранит ключ
    lazy var weatherManager = APIWeatherManager(apiKey: "d7195ca6bf988f63b58b61b868560120")
    let locationManager = CLLocationManager()
    var coordinates = Coordinates(latitude: -75.656771, longitude: 56.222760)

    override func viewDidLoad() {
        super.viewDidLoad()
        //реализуем функции locationManager
        locationManager.delegate = self
        //настройка позволяющая нам понять с какой точностью определять наше положение
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //позволяет запрашивать разрешение на определнение положения при запуске
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        getCurrentWeatherData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        
        coordinates = Coordinates(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        //Определяем город и страну для locationLabel
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude , longitude: coordinates.longitude), completionHandler: { (placemarks , error) -> Void in
            //если ошибки = 0 то выполням код дальше
            guard error == nil else { return }
            //записываем наш опциональный массив в другой массив
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.last! as CLPlacemark
            let userLocality = placemark.locality!
            let userCountry = placemark.country!
            self.locationLabel.text = "\(userLocality), \(userCountry)"
        })
        
    }

    
    
    
    func getCurrentWeatherData() {
        //Получаем реальные данные с сайта. Работает в фоновом режиме
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates, competionHandler: { (result) in
            self.toggleActivityIndicator(on: false)
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
    
    //функция отвечающая за определение включенности индикатора
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        getCurrentWeatherData()
    }
    
    
}



