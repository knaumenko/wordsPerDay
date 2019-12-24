//
//  ConfettiEmitter.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 12/18/19.
//  Copyright © 2019 Kateryna Naumenko. All rights reserved.
//

import UIKit

class ConfettiEmitter: CAEmitterLayer {
    
    enum Colors {
        static let red = UIColor(red: 1.0, green: 0.0, blue: 77.0/255.0, alpha: 1.0)
        static let blue = UIColor.blue
        static let green = UIColor(red: 35.0/255.0 , green: 233/255, blue: 173/255.0, alpha: 1.0)
        static let yellow = UIColor(red: 1, green: 209/255, blue: 77.0/255.0, alpha: 1.0)
    }

    enum Images {
        static let triangle = UIImage(named: "Triangle")!
        static let swirl = UIImage(named: "Spiral")!
    }
    
    var colors:[UIColor] = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow
    ]
    
    var images:[UIImage] = [
        Images.triangle,
        Images.swirl
    ]
    
    var velocities:[Int] = [
        100,
        90,
        150,
        200
    ]
    
    let confettiCount = 16
    
    func generateEmitterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<confettiCount {
            
            let cell = CAEmitterCell()
            
            cell.birthRate = 4.0
            cell.lifetime = 10.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(getRandomVelocity())
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.1
            
            cells.append(cell)
            
            print("i got here")
            
        }
        
        return cells
        
    }
    
    private func getRandomVelocity() -> Int {
        return velocities[Int(arc4random_uniform(4))]
    }
    
    private func getNextColor(i:Int) -> CGColor {
        return colors[i % colors.count].cgColor;
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return images[i % images.count].cgImage!
    }
}
