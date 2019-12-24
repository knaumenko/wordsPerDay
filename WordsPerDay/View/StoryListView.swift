//
//  StoryListView.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 11/7/19.
//  Copyright © 2019 Kateryna Naumenko. All rights reserved.
//

import UIKit

class StoryListView: UIView {
    
    @IBOutlet var writeButton: UIButton! {
        didSet {
            writeButton.backgroundColor = UIColor(red: 28, green: 176, blue: 246)
            writeButton.layer.cornerRadius = 40
        }
    }
    @IBOutlet var footerView: UIView! {
        didSet {
            footerView.backgroundColor = .white
            footerView.layer.masksToBounds = false
            footerView.layer.shadowColor = UIColor.black.cgColor
            footerView.layer.shadowOffset = CGSize(width: 0, height: -5)
            footerView.layer.shadowOpacity = 0.2
            footerView.layer.shadowRadius = 5.0
        }
    }
    
    @IBOutlet var headerView: UIView! {
        didSet {
            headerView.backgroundColor = .white
            headerView.layer.masksToBounds = false
            headerView.layer.shadowColor = UIColor.gray.cgColor
            headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            headerView.layer.shadowOpacity = 0.1
            headerView.layer.shadowRadius = 2.0
            //headerView.addBottomBorder(with: UIColor(red: 232, green: 232, blue: 232), andWidth: 1.0)
        }
    }
    
    @IBOutlet var storyListTableView: UITableView! {
        didSet {
            storyListTableView.contentInset.bottom = 20
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
