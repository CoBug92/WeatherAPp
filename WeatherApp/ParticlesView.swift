//
//  ParticlesView.swift
//  WeatherApp
//
//  Created by Богдан Костюченко on 07/11/2016.
//  Copyright © 2016 Богдан Костюченко. All rights reserved.
//

import UIKit
import SpriteKit

class ParticlesView: SKView {
    //метод для описания сцены
    override func didMoveToSuperview() {
        let scene = SKScene(size: self.frame.size)
        scene.backgroundColor = UIColor.clear
        self.presentScene(scene)
        
        //отключаем фон нашего SKView
        self.allowsTransparency = true
        self.backgroundColor = UIColor.clear
        
        //размещаем частицы на нашей сцене
        if let particles = SKEmitterNode(fileNamed: "ParticlesScene.sks"){
            particles.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
            //в каких пределах должны создаваться наши частицы
            particles.position = CGVector(dx: self.bounds.size.width, dy: 0)
            //добавляем particles на сцену
            scene.addChild(particles)
        }
    }
}
