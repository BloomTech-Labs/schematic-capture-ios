//
//  ClientTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/7/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {
    @IBOutlet weak var clientLogo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numbOfProjectsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
