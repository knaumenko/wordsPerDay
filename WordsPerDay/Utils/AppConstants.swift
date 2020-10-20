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
        static let closeStory = "closeStory"
        static let deleteStory = "deleteStory"
        static let unwindToStoryList = "unwindToStoryList"
    }
    
    enum Colors {
        static let Blue = UIColor(red: 28, green: 176, blue: 246)
        static let deleteButtonRed = UIColor(red: 231, green: 76, blue: 60)
        static let shareButtonYellow = UIColor(red: 254, green: 149, blue: 38)
        static let trackBarYellow = UIColor(red: 255, green: 195, blue: 0)
        static let trackBarWhite = UIColor(red: 250, green: 250, blue: 250)
        static let trackBarGreen = UIColor(red: 122, green: 199, blue: 12)
    }
    
    enum Images {
        static let greenBullet = UIImage(named: "greenCircle")
        static let yellowBullet = UIImage(named: "yellowCircle")
        static let happyDogIcon = UIImage(named: "argos_icon")
        static let sadDogIcon = UIImage(named: "argos_sad_icon")
    }
    
    enum Labels {
        static let streakDayLabel = "days \nstreak"
        static let storyPlaceholder = "StoryText..."
    }
    
    struct Defaults {
        static let defaultWordGoal = 120
        static let trackBarRadius = 3
        static let storyCellHeight = 100.0
    }
}
