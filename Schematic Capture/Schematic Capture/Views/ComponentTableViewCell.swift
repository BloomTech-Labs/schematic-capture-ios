//
//  ComponentTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/19/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ComponentTableViewCell: UITableViewCell {

    var indexLabel = UILabel()
    var nameLabel = UILabel()
    var componentImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.text = "1"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Electric motor"
        componentImageView.translatesAutoresizingMaskIntoConstraints = false
        componentImageView.contentMode = .scaleAspectFill
        componentImageView.image = UIImage(systemName: "camera")
        componentImageView.isUserInteractionEnabled = true 
        
        addSubview(indexLabel)
        addSubview(nameLabel)
        addSubview(componentImageView)
        
        NSLayoutConstraint.activate([
            indexLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            indexLabel.heightAnchor.constraint(equalTo: heightAnchor),
            nameLabel.leftAnchor.constraint(equalTo: indexLabel.rightAnchor, constant: 24.0),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor),

            componentImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            componentImageView.heightAnchor.constraint(equalToConstant: 30.0),
            componentImageView.widthAnchor.constraint(equalToConstant: 30.0),
            componentImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(index: Int, component: ComponentRepresentation) {
        indexLabel.text = "\(index)"
    }
}
