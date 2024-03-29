//
//  StoryListViewController.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 11/5/19.
//  Copyright © 2019 Kateryna Naumenko. All rights reserved.
//

import UIKit
import CoreData

class StoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var streakDayLabel: UILabel!
    @IBOutlet var streakNumberLabel: UILabel!
    @IBOutlet var streakIcon: UIImageView!
    @IBOutlet var storyListTableView: UITableView!
    
    var storyRecords: [DocumentMO] = []
    var fetchResultController: NSFetchedResultsController<DocumentMO>!
    var defaultWordGoal = 120
    var wordGoal: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 28, green: 176, blue: 246)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get word goal
        
        if let wordGoalDefaults = UserDefaults.standard.getWordGoal(){
            wordGoal = wordGoalDefaults
        } else {
            UserDefaults.standard.setNewWordGoal(value: defaultWordGoal)
            wordGoal = defaultWordGoal
        }

        // Do any additional setup after loading the view.
        
        self.storyListTableView.delegate = self
        self.storyListTableView.dataSource = self
        self.storyListTableView.allowsSelection = true
        
        //getting data from the model
        storyRecords = retrieveStories()
        
        streakDayLabel.text = "days \nstreak"
        updateStreak()
        
        self.updateWordCountLabel()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "storyDataCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StoryListTableViewCell
        
        if let storyTitle = storyRecords[indexPath.row].title {
            cell.title?.text = storyTitle
        }
        
        if let storyDate = storyRecords[indexPath.row].created_at {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "ja_JP")
            
            cell.dateLabel?.text = dateFormatter.string(from: storyDate)
        }
        
        cell.wordCountLabel?.text = String(storyRecords[indexPath.row].word_count)
        if storyRecords[indexPath.row].word_count >= 120 {
            cell.bulletImage.image = UIImage(named: "greenCircle")
        } else {
            cell.bulletImage.image = UIImage(named: "yellowCircle")
        }
        cell.textPreview?.text = storyRecords[indexPath.row].text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, complitionHandler) in
            // Deleting rows from the core data
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                context.delete(self.storyRecords[indexPath.row])
                
                appDelegate.saveContext()
            }
            
            complitionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        } else {
            deleteAction.image = UIImage(named: "delete")
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") {
            (action, sourceView, complitionHandler) in
            let defaultText = self.storyRecords[indexPath.row].text
            
            let activityController = UIActivityViewController(activityItems: [defaultText!], applicationActivities: nil)
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            complitionHandler(true)
        }
        
        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        
        if #available(iOS 13.0, *) {
            shareAction.image = UIImage(systemName: "square.and.arrow.up")
        } else {
            shareAction.image = UIImage(named: "share")
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storyListTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                storyListTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                storyListTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                storyListTableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            storyListTableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            storyRecords = fetchedObjects as! [DocumentMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storyListTableView.endUpdates()
    }
    
    private func retrieveStories () -> [DocumentMO] {
        let fetchRequest: NSFetchRequest<DocumentMO> = DocumentMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created_at", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                   return fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        
        return []
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "createStory" {
            let destinationController = segue.destination as! StoryProgressViewController
            destinationController.wordGoal = wordGoal
        }
        
        else if identifier == "displayStory" {
            if let indexPath = storyListTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! StoryProgressViewController
                destinationController.storyDocument = storyRecords[indexPath.row]
                destinationController.wordGoal = wordGoal
            }
        }
        
        else if identifier == "showSettings" {
            let destinationController = segue.destination as! UserSettingsTableViewController
            destinationController.wordGoal = wordGoal
        }
    }
    
    @IBAction func unwindToStoryList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? UserSettingsTableViewController {
            wordGoal = sourceViewController.wordGoal
            self.updateWordCountLabel()
        }
        
        if sender.source is StoryProgressViewController {
            updateStreak()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func updateWordCountLabel() {
        let goalLabel = UILabel()
        goalLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        goalLabel.textColor = UIColor.white               
        goalLabel.text = "Goal: \(wordGoal) words"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: goalLabel)
    }
    
    private func getStreak() -> Int {
        // ok to start counting if first record was today or yesterday
        // if older than that, no streak
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        if Calendar.current.compare(yesterday, to: storyRecords[0].created_at!,
                                    toGranularity: .day) == .orderedDescending
        {
            return 0
        }
        
        var current_date = storyRecords[0].created_at!
        var streak = 0
        var completed = false
        
        // we need to check if the current_date is today, but there are no complete stories, we still need to check yesterday date
        
        for record in storyRecords {
            // record.date == current_date, check if is_complete & update completed flag
            if Calendar.current.compare(record.created_at!, to: current_date, toGranularity: .day) == .orderedSame {
                if record.is_complete {
                    completed = true
                } // else ignore and keep going
            }
            else { //records are ordered descending, so record.date < current_date
                // check if we found a completed record before moving on to next date
                if completed {
                    streak += 1
                    completed = false
                } else if Calendar.current.compare(current_date, to: today, toGranularity: .day) != .orderedSame {
                    break
                }
                
                // check if record is 1 day before current_date
                let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: current_date)!
                if Calendar.current.compare(record.created_at!, to: dayBefore, toGranularity: .day) == .orderedSame {
                    current_date = dayBefore
                    if record.is_complete { completed = true }
                } else { // there's a gap that's greater than a day, so break streak
                    break
                }
            }
        }
        if completed { streak+=1 }
        return streak
    }
    
    private func updateStreak() {
        var streak = 0
        if storyRecords.count > 0 {
            streak = getStreak()
        }
        streakNumberLabel.text = String(streak)
        if streak > 0 {
            streakIcon.image = UIImage(named: "argos_icon")
        }
        else {
            streakIcon.image = UIImage(named: "argos_sad_icon")
        }
    }
}
