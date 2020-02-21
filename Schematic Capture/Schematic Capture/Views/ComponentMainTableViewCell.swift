//
//  ComponentMainTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/18/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import ExpyTableView

class ComponentMainTableViewCell: UITableViewCell, ExpyTableViewHeaderCell {
    
    @IBOutlet weak var componentIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var partNumberLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
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
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        switch state {
        case .willExpand:
            arrowDown(animated: !cellReuse)
            break
        case .willCollapse:
            arrowRight(animated: !cellReuse)
            break
        case .didExpand:
            break
        case .didCollapse:
            showSeparator()
            break
        }
    }
    
    private func updateViews() {
        guard let component = component else { return }
        
        componentIdLabel.text = "\(component.componentId ?? "")"
        descriptionLabel.text = "Description: \(component.componentDescription ?? "")"
        manufacturerLabel.text = "Manufacturer: \(component.manufacturer ?? "")"
        partNumberLabel.text = "Part #: \(component.partNumber ?? "")"
    }
    
    private func arrowDown(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
        }
    }
    
    private func arrowRight(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
    }

}

extension UITableViewCell {

    func showSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        }
    }
}
