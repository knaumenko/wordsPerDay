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
    @IBOutlet var storyListTableView: UITableView!
    
    var storyRecords: [DocumentMO] = []
    var fetchResultController: NSFetchedResultsController<DocumentMO>!
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: give colors readable names, save them as constants somewhere, e.g. constants/UIColors.swift
        navigationController?.navigationBar.barTintColor = UIColor(red: 28, green: 176, blue: 246)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.storyListTableView.delegate = self
        self.storyListTableView.dataSource = self
        self.storyListTableView.allowsSelection = true
        
        // TODO: refactor this into a function, which will eventually fetch the correct numbers from data
        streakDayLabel.text = "days \nstreak"
        streakNumberLabel.text = "10"
        
        // TODO: refactor this into a function, which will eventually fetch goal from settings
        let goalLabel = UILabel()
        goalLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        goalLabel.textColor = UIColor.white
        goalLabel.text = "Goal: 120 words"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: goalLabel)
        
        //getting data from the model
        storyRecords = retrieveStories()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "storyDataCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StoryListTableViewCell
        
        if let storyDate = storyRecords[indexPath.row].created_at {
            // TODO: dateFormatter should just be a class constant
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "ja_JP")
            
            cell.dateLabel?.text = dateFormatter.string(from: storyDate)
        }
        
        cell.wordCountLabel?.text = String(storyRecords[indexPath.row].word_count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: what does this mean? magic numbers should always be named constants at top of class
        return 60.0
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
        // TODO: you don't need this variable
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
        
        // TODO: where did this string come from? should be a constant
        // so you don't get bugs with some strings not matching other strings in random places
        if identifier == "createStory" {
            print("creating a note")
        }
        
        else if identifier == "displayStory" {
            if let indexPath = storyListTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! StoryProgressViewController
                destinationController.storyDocument = storyRecords[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToStoryList(sender: UIStoryboardSegue) {}
}
