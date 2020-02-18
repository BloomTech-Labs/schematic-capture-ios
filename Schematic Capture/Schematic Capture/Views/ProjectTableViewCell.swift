//
//  ProjectTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/7/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numbOfJobSheetLabel: UILabel!
    
    var project: Project? {
        didSet {
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
        guard let project = project else { return }
        nameLabel.text = project.name
        numbOfJobSheetLabel.text = project.jobSheets != nil ? "\(project.jobSheets!.count) Jobs" : "0 Jobs"
    }
}
