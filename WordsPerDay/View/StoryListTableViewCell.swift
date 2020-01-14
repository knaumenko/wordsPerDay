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
    @IBOutlet var textPreview: UILabel!
    @IBOutlet var bulletImage: UIImageView!
    @IBOutlet var title: UILabel!
    
    @IBOutlet var cellBorderView: UIView! {
        didSet {
            cellBorderView.addBottomBorder(with: UIColor(red: 112, green: 112, blue: 112), andWidth: 1.0)
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
