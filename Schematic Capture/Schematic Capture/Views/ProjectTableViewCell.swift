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
    
    private func updateViews() {
        guard let project = project else { return }
        nameLabel.text = project.name
        numbOfJobSheetLabel.text = project.jobSheets != nil ? "\(project.jobSheets!.count)" + (project.jobSheets!.count > 1 ? " jobs" : " job") : "0 Jobs"
    }
}
