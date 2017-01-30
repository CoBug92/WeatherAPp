//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 11/10/16.
//  Copyright © 2016 Bogdan Kostyuchenko. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //с помощью этого из текста в ширину и долготу и наоборт
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: -75.656771, longitude: 56.222760), completionHandler: { placemark, error in
            //если ошибки = 0 то выполням код дальше
            guard error == nil else { return }
            //записываем наш опциональный массив в другой массив
            guard let placemarks = placemark else { return }
            print(placemarks)
        })
    }
}
