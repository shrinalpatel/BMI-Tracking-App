//
//  TableViewCell.swift
//  BMITrackingApp
//
//  Created by Shrinal Patel on 17/12/21.
//  Final Exam for MAPD714 - iOS Development
//  Description: This is a simple BMI Calculator app to calculate BMI In both Standard and Imperial units. It also supports persistant data storage.

import UIKit
import CoreData

class TableViewCell: UITableViewCell {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var BMIResultLabel: UILabel!
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
