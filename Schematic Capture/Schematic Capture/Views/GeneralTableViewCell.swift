//
//  GeneralTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SDWebImage

protocol SelectedCellDelegate: NSObject {
    func selectedCell(cell: GeneralTableViewCell)
}

class GeneralTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var regularImageView = UIImageView()
    
    var imagePicker: ImagePicker!
    weak var selectedCellDelegate: SelectedCellDelegate?
    weak var delegate: ImagePickerDelegate?
    
    var viewController: UIViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
                
        regularImageView.isHidden = true
        regularImageView.contentMode = .scaleAspectFit
        regularImageView.translatesAutoresizingMaskIntoConstraints = false
        regularImageView.image = UIImage(systemName: "camera")
        regularImageView.isUserInteractionEnabled = true
        contentView.addSubview(regularImageView)
        
        regularImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        
        NSLayoutConstraint.activate([
            regularImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            regularImageView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30),
            regularImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -25),
            regularImageView.widthAnchor.constraint(equalTo: regularImageView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(entityName: EntityNames, value: Any) {
        switch entityName {
        case .client:
            guard let client = value as? Client else { return }
            textLabel?.text = client.companyName
            if let projects = Int(client.projects ?? "0") {
                if  projects > 1 {
                    detailTextLabel?.text = "\(client.projects ?? "0") projects"
                } else {
                    detailTextLabel?.text = " \(client.projects ?? "0") project"
                }
            }
        case .project:
            guard let project = value as? Project else { return }
            textLabel?.text = project.name
            if project.completed == true {
                detailTextLabel?.text  = "Assigned on 1/4/2020 - Complete"
            } else {
                detailTextLabel?.text  = "Assigned on 1/4/2020 - Incomplete"
            }
        case .jobSheet:
            guard let jobsheet = value as? JobSheet else { return }
           textLabel?.text = "\(jobsheet.name ?? "")"
           if jobsheet.completed == true {
               detailTextLabel?.text  = "Complete"
           } else {
               detailTextLabel?.text  = "Incomplete"
           }
        case .component:
            guard let component = value as? Component else { return }
            textLabel?.text = "\(component.id). \(component.descriptions ?? "")"
            regularImageView.isHidden = false
        }
    }
    
    @objc func imageViewTapped() {
        selectedCellDelegate?.selectedCell(cell: self)
    }
}

// MARK: - ImageDoneEditingDelegate
extension GeneralTableViewCell: ImageDoneEditingDelegate {
    
    func ImageDoneEditing(image: UIImage?) {
        self.regularImageView.image = image
    }
}
