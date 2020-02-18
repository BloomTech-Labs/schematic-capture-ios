//
//  JobSheetTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class JobSheetTableViewCell: UITableViewCell {

    @IBOutlet weak var jobSheetNameLabel: UILabel!
    @IBOutlet weak var numOfComponentsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var jobSheet: JobSheet? {
        didSet{
            updateViews()
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
    
    private func updateViews() {
        guard let jobSheet = jobSheet else { return }
        
        jobSheetNameLabel.text = jobSheet.name
        numOfComponentsLabel.text = jobSheet.components != nil ? "\(jobSheet.components!.count) Components" : "0 Components"
        statusLabel.text = jobSheet.status
    }

}
