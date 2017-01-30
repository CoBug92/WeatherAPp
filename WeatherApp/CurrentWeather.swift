//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 29/10/2016.
//  Copyright © 2016 Богдан Костюченко. All rights reserved.
//

import Foundation
import UIKit    //испортируем для UIImage

struct CurrentWeather {
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let pressure: Double
    let icon: UIImage
}

//подписываемся под протокол JSONDecodable
extension CurrentWeather: JSONDecodable {
    init?(JSON: [String: AnyObject]) {
        //получаем JSON  и пытаемся по ключам найти нужные данные и кастим ее в дабл
        guard let temperature = JSON["temperature"] as? Double,
            let apparentTemperature = JSON["apparentTemperature"] as? Double,
            let humidity = JSON["humidity"] as? Double,
            let pressure = JSON["pressure"] as? Double,
            let iconString = JSON["icon"] as? String
            else {
                return nil
        }
        let icon = WeatherIconManager(rawValue: iconString).image
        
        self.temperature = temperature
        self.apparentTemperature = apparentTemperature
        self.humidity = humidity
        self.pressure = pressure
        self.icon = icon
    }
}

//Екстеншен для красивого вывода в лейблах
extension CurrentWeather {
    var pressureString: String {
        return "\(Int(pressure * 0.750062)) mm"
    }
    
    var humidityString: String {
        return "\(Int(humidity * 100)) %"
    }
    
    var temperatureString: String {
        return "\(Int(5 / 9 * (temperature - 32)))˚C"
    }
    
    var appearentTemperatureString: String {
        return "Feels like: \(Int(5 / 9 * (apparentTemperature - 32)))˚C"
    }
    
}
