//
//  APIManager.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 31/10/2016.
//  Copyright © 2016 Богдан Костюченко. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

enum APIResult<T>{
    case Success(T)
    case Failure(Error)
    
}

protocol APIManager {
    //указываем конфигурацию сессии
    var sessionConfiguration: URLSessionConfiguration { get }
    //создаем сессии на основе sessionConfiguration
    var session: URLSession { get }
    
    //2 метода для получения данных
    //функция возвращающая URLSessionDataTask
    func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
    func fetch<T>(request: URLRequest, pars: ([String: AnyObject]) -> T?, completionHandler: (APIResult<T>) -> Void)
    
    init(sessionConfiguration: URLSessionConfiguration)
}
