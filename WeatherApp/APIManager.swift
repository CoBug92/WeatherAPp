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
    
    //2 метода для получения данных:
    //функция возвращающая URLSessionDataTask
    func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
    func fetch<T>(request: URLRequest, pars: ([String: AnyObject]) -> T?, completionHandler: (APIResult<T>) -> Void)
    
    init(sessionConfiguration: URLSessionConfiguration)
}

extension APIManager {
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //если у нас не HTTP
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: BOGNetworkingErrorDomain, code: 100 , userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    }
                    catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default: print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, pars: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            guard let json = json else {
                if let error = error {
                    completionHandler(APIResult<T>.Failure(error))
                }
                return
            }
            
            if let value = pars(json) {
                completionHandler(APIResult<T>.Success(value))
            } else {
                let error = NSError(domain: BOGNetworkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(APIResult<T>.Failure(error))
                
            }
            
        }
        dataTask.resume()
        
    }
}












