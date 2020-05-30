//
//  UserDefaults+Ext.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 2/19/20.
//  Copyright © 2020 Kateryna Naumenko. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setNewWordGoal(value: Int?) {
        UserDefaults.standard.set(value, forKey: "Word_Goal")
    }
    
    func getWordGoal() -> Int? {
        return UserDefaults.standard.value(forKey: "Word_Goal") as? Int
    }
    
}
