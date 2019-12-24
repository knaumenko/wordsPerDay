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
            writingProgressBar.progressTintColor = UIColor(red: 255, green: 195, blue: 0)
            writingProgressBar.trackTintColor = UIColor(red: 250, green: 250, blue: 250)
            writingProgressBar.layer.cornerRadius = 3
            writingProgressBar.clipsToBounds = true
            writingProgressBar.layer.sublayers![1].cornerRadius = 3
            writingProgressBar.subviews[1].clipsToBounds = true
        }
    }
    @IBOutlet var progressBarHeader: UIView!
    
    var storyDocument: DocumentMO!
    
    var currentWordCount: Float = 0.0
    var wordGoal = 120
    var emitter = ConfettiEmitter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storyText.delegate = self
        storyText.becomeFirstResponder()
        writingProgressBar.progress = currentWordCount
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let story = storyDocument {
            storyText.text = story.text
            perform(#selector(updateProgress), with: nil, afterDelay: 1.0)
        }
        
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
    }
    
    @objc func updateProgress() {
        let wordCount = getWordCount()
        let percentage = Float(wordCount)/Float(wordGoal)
        writingProgressBar.setProgress(percentage, animated: true)
        
        if wordCount >= 120 {
            writingProgressBar.progressTintColor = UIColor(red: 122, green: 199, blue: 12)
            emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
            emitter.emitterShape = CAEmitterLayerEmitterShape.line
            emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
            emitter.emitterCells = emitter.generateEmitterCells()
            self.view.layer.addSublayer(emitter)
            
            perform(#selector(endConfetti), with: emitter, afterDelay: 1.5)
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        
        //save text to the core data
        let words = getWordCount()
        if words <= 0 {return}
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if storyDocument == nil {
                storyDocument = DocumentMO(context: appDelegate.persistentContainer.viewContext)
            }
            storyDocument.text = self.storyText.text
            storyDocument.created_at = Date()
            storyDocument.word_count = Int32(words)
            storyDocument.last_updated = Date()
            
            appDelegate.saveContext()
        }
    }
    
    func getWordCount() -> Int {
        return self.storyText.text.split { !$0.isLetter }.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func endConfetti(emitterLayer:CAEmitterLayer) {
       emitterLayer.lifetime = 0.0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
