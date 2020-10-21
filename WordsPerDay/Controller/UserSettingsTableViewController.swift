//
//  UserSettingsTableViewController.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 2/13/20.
//  Copyright © 2020 Kateryna Naumenko. All rights reserved.
//

import UIKit

class UserSettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    var wordGoal: Int!
    
    @IBOutlet var wordGoalTextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        tableView.separatorStyle = .none
        wordGoalTextField.text = String(wordGoal)
        wordGoalTextField.delegate = self
        doneButton.isEnabled = false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == wordGoalTextField {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            return string == numberFiltered
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneButton.isEnabled = true
    }
    
    @IBAction func saveSettings(sender: AnyObject) {
        if let text = wordGoalTextField.text, !text.isEmpty {
            wordGoal = Int(wordGoalTextField.text!)
            UserDefaults.standard.setNewWordGoal(value: wordGoal)
        }
           
        performSegue(withIdentifier: Constants.SegueIdentifiers.unwindToStoryList, sender: self)
    }
    
}
