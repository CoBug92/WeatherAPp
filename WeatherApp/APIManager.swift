//
//  APIManager.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 31/10/2016.
//  Copyright © 2016 Богдан Костюченко. All rights reserved.
//

import Foundation


typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?,  HTTPURLResponse?, Error?) -> Void

protocol FinalURLPoint {
    //get значит что мы можем смотреть, но не можем присваивать значения
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

enum APIResult<T>{
    case Success(T)
    case Failure(Error)
    
}

//протокол для
protocol JSONDecodable {
    //проваливающийся инициализатор, который может вернуть nil
    init?(JSON: [String: AnyObject])
}


protocol APIManager {
    //указываем конфигурацию сессии
    var sessionConfiguration: URLSessionConfiguration { get }
    //создаем сессии на основе sessionConfiguration
    var session: URLSession { get }
    
    //Метод для получения данных
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    //метод для использованния данных, чтобы обновить наш интерфейс
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
}

extension APIManager {
    //Метод для получения данных
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        //От нас ожидается датаТаск
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //если у нас приходит не HTTP
            guard let HTTPResponse = response as? HTTPURLResponse else {
                //Описание ошибки
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                //создаем ошибку.
                let error = NSError(domain: BKNetworkingErrorDomain, code: MissingHTTPResponseError , userInfo: userInfo)
                completionHandler(nil, nil, error)
                //выход из guard блока
                return
            }
            //Когда данные =nil
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
                        //если не удалось создать JSON объект
                        completionHandler(nil, HTTPResponse, error)
                    }
                default: print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    //метод для использованния данных, чтобы обновить наш интерфейс
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        //получаем данные с метода JSONTaskWith
        //DispatchQueue.main.async пустили в главный поток
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async {
                //не равен ли json nil
                guard let json = json else {
                    //если = nil то проверяем ошибки
                    if let error = error {
                        //передаем ошибки в completionHandler
                        completionHandler(APIResult<T>.Failure(error))
                    }
                    //выход из guard блока
                    return
                }
                //получается ли преобразовать [String: AnyObject] в формат Т
                if let value = parse(json) {
                    completionHandler(APIResult<T>.Success(value))
                } else {
                    //создаем ошибку
                    let error = NSError(domain: BKNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completionHandler(APIResult<T>.Failure(error))
                    
                }
            }
            
        }
        //функция закончена
        dataTask.resume()
    }
}












