//
//  ComponentTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/19/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyDropbox

class ComponentTableViewCell: UITableViewCell {

    var indexLabel = UILabel()
    var nameLabel = UILabel()
    var componentImageView = UIImageView()
    
    var dropboxController: DropboxController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.text = "1"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Electric motor"
        componentImageView.translatesAutoresizingMaskIntoConstraints = false
        componentImageView.contentMode = .scaleAspectFill
        componentImageView.clipsToBounds = true
        componentImageView.image = UIImage(systemName: "camera")
        componentImageView.isUserInteractionEnabled = true 
        
        addSubview(indexLabel)
        addSubview(nameLabel)
        addSubview(componentImageView)
        
        NSLayoutConstraint.activate([
            indexLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            indexLabel.heightAnchor.constraint(equalTo: heightAnchor),
            nameLabel.leftAnchor.constraint(equalTo: indexLabel.rightAnchor, constant: 16.0),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor),
            
            componentImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            componentImageView.heightAnchor.constraint(equalToConstant: 32.0),
            componentImageView.widthAnchor.constraint(equalToConstant: 32.0),
            componentImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLabel.rightAnchor.constraint(equalTo: componentImageView.leftAnchor, constant: -8.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Do we need index?
    func updateViews(component: ComponentRepresentation) {
        indexLabel.text = "\(component.id)"
        
        print("COMPONENT DESCRIPTION: \(String(describing: component.componentApplication))")
        
        nameLabel.text = component.componentApplication
        guard let image = component.image else { return }
            print("IMAGE:", image)
        
        self.componentImageView.sd_setImage(with: URL(string: image), completed: .none)

    }
}
