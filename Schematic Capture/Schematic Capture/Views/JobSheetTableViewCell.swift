//
//  JobSheetTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit


class JobSheetTableViewCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var numberOfJobSheetLabel = UILabel()
    
    var jobSheet: JobSheetRepresentation? {
        didSet{
            updateViews()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfJobSheetLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        addSubview(numberOfJobSheetLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViews() {
        guard let jobSheet = jobSheet else { return }
        nameLabel.text = jobSheet.name
    }
}
