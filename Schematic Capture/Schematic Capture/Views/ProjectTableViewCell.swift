//
//  ProjectTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/7/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var numberOfJobSheetLabel = UILabel()
    var statusLabel = UILabel()
    
    var project: ProjectRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfJobSheetLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        statusLabel.textAlignment = .center
        
        addSubview(nameLabel)
        addSubview(numberOfJobSheetLabel)
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor),
    
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            statusLabel.heightAnchor.constraint(equalTo: heightAnchor, constant: -24.0),
            statusLabel.widthAnchor.constraint(equalToConstant: 100),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func updateViews() {
        guard let project = project else { return }
        nameLabel.text = project.name
        
        if !project.completed! {
            statusLabel.backgroundColor = UIColor(red: 250.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1.0)
            statusLabel.textColor = .label
            statusLabel.text = "Incomplete"
        } else {
            statusLabel.textColor = .systemGray
        }
//
//        numberOfJobSheetLabel.text = project.jobSheets != nil ? "\(project.jobSheets!.count)" + (project.jobSheets!.count > 1 ? " jobs" : " job") : "0 Jobs"
    }
}
