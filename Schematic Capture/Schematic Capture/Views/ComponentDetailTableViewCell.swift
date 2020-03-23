//
//  ComponentDetailTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/18/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import ExpyTableView

class ComponentDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rlCategoryLabel: UILabel!
    @IBOutlet weak var rlNumberLabel: UILabel!
    @IBOutlet weak var stockCodeLabel: UILabel!
    @IBOutlet weak var electricalAddressLabel: UILabel!
    @IBOutlet weak var componentApplicationLabel: UILabel!
    @IBOutlet weak var referenceTagLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var resourcesLabel: UILabel!
    @IBOutlet weak var cutsheetLabel: UILabel!
    @IBOutlet weak var maintenanceVideoLabel: UILabel!
    @IBOutlet weak var storePartNumberLabel: UILabel!
    
    var component: Component? {
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
        guard let component = component else { return }
        
        rlCategoryLabel.text = "RL Category: \(component.rlCategory ?? "")"
        rlNumberLabel.text = "RL Number: \(component.rlNumber ?? "")"
        stockCodeLabel.text = "Stock Code: \(component.stockCode ?? "")"
        electricalAddressLabel.text = "Eletrical Address: \(component.electricalAddress ?? "")"
        componentApplicationLabel.text = "Component Application: \(component.componentApplication ?? "")"
        referenceTagLabel.text = "Reference Tag: \(component.referenceTag ?? "")"
        settingsLabel.text = "Settings: \(component.settings ?? "")"
        imageLabel.text = "Image: \(component.image ?? "")"
        resourcesLabel.text = "Resources: \(component.resources ?? "")"
        cutsheetLabel.text = "Cutsheet: \(component.cutSheet ?? "")"
        maintenanceVideoLabel.text = "Maintenance Video: \(component.maintenanceVideo ?? "")"
        storePartNumberLabel.text = "Sotre's Part #: \(component.storePartNumber ?? "")"
        
       
    }

}
