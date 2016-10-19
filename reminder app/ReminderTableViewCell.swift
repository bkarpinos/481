//
//  ReminderTableViewCell.swift
//  reminder app
//
//  Created by Brett Karpinos on 10/19/16.
//
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    //MARK: Properties
    //CURRENTLY ON STEP ABOUT LOADING INITIAL DATA!!!!!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
