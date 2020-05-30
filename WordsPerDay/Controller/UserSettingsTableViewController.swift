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
    
    // MARK: - Table view data source
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func saveSettings(sender: AnyObject) {
        if let text = wordGoalTextField.text, !text.isEmpty {
            wordGoal = Int(wordGoalTextField.text!)
            UserDefaults.standard.setNewWordGoal(value: wordGoal)
        }
           
        performSegue(withIdentifier: "unwindToStoryList", sender: self)
    }
    
}
