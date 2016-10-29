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
    @IBOutlet weak var tamperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
    }
    
}

