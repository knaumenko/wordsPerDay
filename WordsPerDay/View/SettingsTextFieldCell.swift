//
//  SettingsTextFieldCell.swift
//  WordsPerDay
//
//  Created by Kateryna Naumenko on 2/17/20.
//  Copyright © 2020 Kateryna Naumenko. All rights reserved.
//

import UIKit

class SettingsTextFieldCell: UITableViewCell {
    
    @IBOutlet var shortTextLabel: UILabel!
    @IBOutlet var borderView: UIView! {
        didSet {
            borderView.addBottomBorder(with: UIColor(red: 170, green: 176, blue: 181), andWidth: 2.0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
