//
//  ClientTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/15/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    var numberOfJobSheetLabel = UILabel()
    var statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        nameLabel.textColor = .label
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 5
        
        addSubview(nameLabel)
        addSubview(numberOfJobSheetLabel)
        addSubview(statusLabel)
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor),
            
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            statusLabel.heightAnchor.constraint(equalTo: heightAnchor, constant: -24.0),
            statusLabel.widthAnchor.constraint(equalToConstant: 100),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func updateViews(viewTypes: ViewTypes, value: Any) {
        switch viewTypes {
            case .clients:
                guard let client = value as? Client else { return }
                nameLabel.text = client.companyName
            case .projects:
                guard let project = value as? ProjectRepresentation else { return }
                nameLabel.text = project.name
                
                if !project.completed! {
                    statusLabel.backgroundColor = UIColor(red: 250.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1.0)
                    statusLabel.textColor = .label
                    statusLabel.text = "Incomplete"
                } else {
                    statusLabel.textColor = .systemGray
            }
            case .jobsheets:
                guard let jobsheet = value as? JobSheetRepresentation else { return }
                nameLabel.text = jobsheet.name
                
                if !jobsheet.completed {
                    statusLabel.backgroundColor = UIColor(red: 250.0/255.0, green: 86.0/255.0, blue: 86.0/255.0, alpha: 1.0)
                    statusLabel.textColor = .label
                    statusLabel.text = "Incomplete"
                } else {
                    statusLabel.textColor = .systemGray
            }
            case .components:
                guard let component = value as? Component else { return }
                nameLabel.text = component.componentApplication
            case .componentDetails:
                break
        }
    }
    
}
