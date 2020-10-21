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
            writingProgressBar.progressTintColor = Constants.Colors.trackBarYellow
            writingProgressBar.trackTintColor = Constants.Colors.trackBarWhite
            writingProgressBar.layer.cornerRadius = CGFloat(Constants.Defaults.trackBarRadius)
            writingProgressBar.clipsToBounds = true
            writingProgressBar.layer.sublayers![1].cornerRadius = CGFloat(Constants.Defaults.trackBarRadius)
            writingProgressBar.subviews[1].clipsToBounds = true
        }
    }
    @IBOutlet var progressBarHeader: UIView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var storyTitle: UITextField!
    
    var storyDocument: DocumentMO!
    
    var wordGoal: Int = 0
    var emitter = ConfettiEmitter()
    var unsavedText = false
    var placeholder = UILabel()
    var storyCompleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .gray
        
        //settin up the text view
        storyText.delegate = self
        storyText.becomeFirstResponder()
        writingProgressBar.progress = 0.0
        placeholder.text = Constants.Labels.storyPlaceholder
        placeholder.font = UIFont.italicSystemFont(ofSize: (storyText.font?.pointSize)!)
        placeholder.sizeToFit()
        storyText.addSubview(placeholder)
        placeholder.frame.origin = CGPoint(x: 5, y: (storyText.font?.pointSize)! / 2)
        placeholder.textColor = UIColor.lightGray
        
        self.saveButton.target = self
        self.saveButton.action = #selector(StoryProgressViewController.saveStory)
        self.saveButton.isEnabled = false
        self.deleteButton.isEnabled = false
        
        storyTitle.addTarget(self, action: #selector(StoryProgressViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        self.shareButton.action = #selector(StoryProgressViewController.shareStory)
        self.shareButton.isEnabled = false
    }
    
    // Controls for different View states
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let story = storyDocument {
            storyTitle.text = story.title
            storyText.text = story.text
            storyCompleted = story.was_completed
            perform(#selector(updateProgress), with: nil, afterDelay: 1.0)
            deleteButton.isEnabled = true
            shareButton.isEnabled = true
        }
        placeholder.isHidden = !storyText.text.isEmpty
        
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let wordCount = getWordCount()
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
           
           performSegue(withIdentifier: Constants.SegueIdentifiers.closeStory, sender: nil)
       }
    
    // Updating Progress bar
    
    @objc private func updateProgress() {
        let wordCount = getWordCount()
        let percentage = Float(wordCount)/Float(wordGoal)
        writingProgressBar.setProgress(percentage, animated: true)
        
        if wordCount >= wordGoal {
            writingProgressBar.progressTintColor = Constants.Colors.trackBarGreen
            if !storyCompleted {
                showConfetti()
                storyCompleted = true
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
    
    private func showConfetti() {
        emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        emitter.emitterCells = emitter.generateEmitterCells()
        self.view.layer.addSublayer(emitter)
        
        perform(#selector(endConfetti), with: emitter, afterDelay: 1.5)
    }
    
    // Saving or updating the story
    
    @objc private func saveStory() {
        //save text to the core data
        let words = getWordCount()
        if words <= 0 {return}
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if storyDocument == nil {
                storyDocument = DocumentMO(context: appDelegate.persistentContainer.viewContext)
            }
            storyDocument.text = self.storyText.text
            if storyDocument.created_at == nil{
                storyDocument.created_at = Date()
            }
            storyDocument.word_count = Int32(words)
            storyDocument.last_updated = Date()
            storyDocument.was_completed = storyCompleted

            if let title = self.storyTitle.text {
                storyDocument.title = title
            }
            
            appDelegate.saveContext()
        }
        
        saveButton.isEnabled = false
        self.navigationItem.hidesBackButton = false
        deleteButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    @objc private func shareStory() {
        let activityController = UIActivityViewController(activityItems: [storyDocument.text!], applicationActivities: nil)
                   
            if let popoverController = activityController.popoverPresentationController {
               popoverController.sourceView = self.view
            }

            self.present(activityController, animated: true, completion: nil)
    }
    
    // deleting a story
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        if identifier == Constants.SegueIdentifiers.deleteStory {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                context.delete(storyDocument)
                
                appDelegate.saveContext()
            }
        }
    }
}
