//
//  ImageTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/21/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    var componentImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if imageView?.image == UIImage(systemName: "camera") {
            
        }
        
        addSubview(componentImageView)
        componentImageView.translatesAutoresizingMaskIntoConstraints = false
        componentImageView.contentMode = .scaleAspectFill
        componentImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            componentImageView.widthAnchor.constraint(equalTo: widthAnchor),
            componentImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
