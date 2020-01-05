//
//  StoryProgressViewController.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 11/19/19.
//  Copyright © 2019 Kateryna Naumenko. All rights reserved.
//

import UIKit

class StoryProgressViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var storyText: UITextView!
    @IBOutlet var writingProgressBar: UIProgressView! {
        didSet {
            // TODO: give these colors names
            writingProgressBar.progressTintColor = UIColor(red: 255, green: 195, blue: 0)
            writingProgressBar.trackTintColor = UIColor(red: 250, green: 250, blue: 250)
            writingProgressBar.layer.cornerRadius = 3
            writingProgressBar.clipsToBounds = true
            writingProgressBar.layer.sublayers![1].cornerRadius = 3
            writingProgressBar.subviews[1].clipsToBounds = true
        }
    }
    @IBOutlet var progressBarHeader: UIView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var storyTitle: UITextField!
    
    var storyDocument: DocumentMO!
    
    // this is only used one time as init, don't need to declare, just use 0.0
    // also, why not just 0 (int) instead of a float
    var currentWordCount: Float = 0.0
    var wordGoal = 120
    var emitter = ConfettiEmitter()
    var unsavedText = false
    var placeholder = UILabel()
    var storyComplete: Bool = false // :storyCompleted would be better
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //settin up the text view
        storyText.delegate = self
        storyText.becomeFirstResponder()
        writingProgressBar.progress = currentWordCount // should add whitespace around this
        placeholder.text = "StoryText..."
        placeholder.font = UIFont.italicSystemFont(ofSize: (storyText.font?.pointSize)!)
        placeholder.sizeToFit()
        storyText.addSubview(placeholder)
        placeholder.frame.origin = CGPoint(x: 5, y: (storyText.font?.pointSize)! / 2)
        placeholder.textColor = UIColor.lightGray
        
        self.saveButton.target = self
        self.saveButton.action = #selector(StoryProgressViewController.saveStory)
        self.saveButton.isEnabled = false
        
        storyTitle.addTarget(self, action: #selector(StoryProgressViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // Controls for different View states
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let story = storyDocument {
            storyTitle.text = story.title
            storyText.text = story.text
            // past tense be more obvious of what this means, story.was_completed, story.completed
            storyComplete = story.is_complete
            perform(#selector(updateProgress), with: nil, afterDelay: 1.0)
        }
        placeholder.isHidden = !storyText.text.isEmpty
        
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // why not put all this code into updateProgress()?
        // you're calling getWordCount() twice, once here, then in updateProgress
        // this logic is useful anytime you update progress
        let wordCount = getWordCount()
        // you still have a bug when you copy paste more than 1 word at the end?
        // can just set progress to 100% if wordCount > wordGoal
        if wordCount > 0 && wordCount <= wordGoal {
            perform(#selector(updateProgress), with: nil, afterDelay: 1.0)
        }

        saveButton.isEnabled = true
        self.navigationItem.hidesBackButton = true
        placeholder.isHidden = !storyText.text.isEmpty
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           // Restore the navigation bar to default
           navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
           navigationController?.navigationBar.shadowImage = nil
           
           performSegue(withIdentifier: "closeStory", sender: nil)
       }
    
    // Updating Progress bar
    
    @objc private func updateProgress() {

        let wordCount = getWordCount()
        let percentage = Float(wordCount)/Float(wordGoal)
        writingProgressBar.setProgress(percentage, animated: true)
        
        if wordCount >= wordGoal {
            writingProgressBar.progressTintColor = UIColor(red: 122, green: 199, blue: 12)
            if !storyComplete {
                // refactor into createEmitter(), showConfetti() or something
                emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
                emitter.emitterShape = CAEmitterLayerEmitterShape.line
                emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
                emitter.emitterCells = emitter.generateEmitterCells()
                self.view.layer.addSublayer(emitter)
                
                perform(#selector(endConfetti), with: emitter, afterDelay: 1.5)
                
                storyComplete = true // does this update coreData?
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveButton.isEnabled = true
    }
    
    // helper methods
    private func getWordCount() -> Int {
        return self.storyText.text.split { !$0.isLetter && !$0.isNumber }.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func endConfetti(emitterLayer:CAEmitterLayer) {
        emitterLayer.lifetime = 0.0
    }
    
    // Saving or updating the story
    
    @objc private func saveStory() {
        //save text to the core data
        let words = getWordCount()
        // what if they had typed in some symbols?
        // i think you mean if the document is empty or just whitespaces, don't save
        if words <= 0 {return}
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if storyDocument == nil {
                storyDocument = DocumentMO(context: appDelegate.persistentContainer.viewContext)
            }
            storyDocument.text = self.storyText.text
            storyDocument.created_at = Date()
            storyDocument.word_count = Int32(words)
            storyDocument.last_updated = Date()
            storyDocument.is_complete = storyComplete
            if let title = self.storyTitle.text {
                storyDocument.title = title
            }
            
            appDelegate.saveContext()
        }
        
        saveButton.isEnabled = false
        self.navigationItem.hidesBackButton = false
    }
}
