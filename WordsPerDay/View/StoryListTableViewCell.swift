//
//  StoryListTableViewCell.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 11/1/19.
//  Copyright © 2019 Kateryna Naumenko. All rights reserved.
//

import UIKit

class StoryListTableViewCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var wordCountLabel: UILabel!
    
    @IBOutlet var cellBorderView: UIView! {
        didSet {
            cellBorderView.layer.cornerRadius = 20
            cellBorderView.layer.borderWidth = 1
            cellBorderView.layer.borderColor = UIColor(red: 122, green: 199, blue: 12).cgColor
            //cellBorderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
            // another
            //cellBorderView.addBottomBorder(with: UIColor(red: 122, green: 199, blue: 12), andWidth: 1.0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
