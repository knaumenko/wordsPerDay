//
//  AppConstants.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 10/19/20.
//  Copyright © 2020 Kateryna Naumenko. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    enum CellIdentifiers {
        static let storyDataCell = "storyDataCell"
        
    }
    
    enum SegueIdentifiers {
        static let newStory = "createStory"
        static let displayStory = "displayStory"
        static let showSettings = "showSettings"
    }
    
    enum Colors {
        static let Blue = UIColor(red: 28, green: 176, blue: 246)
        static let deleteButtonRed = UIColor(red: 231, green: 76, blue: 60)
        static let shareButtonYellow = UIColor(red: 254, green: 149, blue: 38)
    }
    
    enum Images {
        static let greenBullet = UIImage(named: "greenCircle")
        static let yellowBullet = UIImage(named: "yellowCircle")
        static let happyDogIcon = UIImage(named: "argos_icon")
        static let sadDogIcon = UIImage(named: "argos_sad_icon")
    }
    
    enum Font {
        
    }
    
    enum Labels {
        static let streakDayLabel = "days \nstreak"
    }
    
    enum Defaults {
        static let defaultWordGoal = 120
    }
}
