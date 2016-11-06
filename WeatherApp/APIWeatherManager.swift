//
//  APIWeatherManager.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 01/11/2016.
//  Copyright © 2016 Богдан Костюченко. All rights reserved.
//

import Foundation


struct Coordinates {
    let latitude: Double
    let longitude: Double
}

//Енум для вычисления адреса и создавать отдельный запрос. FinalURLPoint в APIManager.swift
enum ForecastType: FinalURLPoint {
    //узнать текущую погоду
    case Current(apiKey: String, coordinates: Coordinates)
    //создаем переменные адреса и пути
    var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    var path: String {
        switch self {
        case .Current(let apiKey, let coordinates):
            return "/forecast/\(apiKey)/\(coordinates.latitude),\(coordinates.longitude)"
        }
    }
    //св-во запроса
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}


final class APIWeatherManager: APIManager {
    
    let sessionConfiguration: URLSessionConfiguration
    //будет создаваться только тогда когда мы будем обращаться
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    let apiKey: String
    //создаем инициализатор
    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    //convenience (более удобный) инициализатор
     convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    //возвращает текущую погоду
    func fetchCurrentWeatherWith(coordinates: Coordinates, competionHandler: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request
        //вызываем метод фетч с расширения в APIManager
        fetch(request: request, parse: {(json) -> CurrentWeather? in
            //получится ли из json получить словарь и кастим в новый словарь
            if let dictionary = json["currently"] as? [String: AnyObject] {
                //возвращаем CurrentWeather
                return CurrentWeather(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: competionHandler)
    }
}
