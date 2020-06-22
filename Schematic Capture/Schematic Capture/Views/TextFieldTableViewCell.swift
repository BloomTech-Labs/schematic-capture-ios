//
//  TextFieldTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/22/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class  TextFieldTableViewCell: UITableViewCell {
    
    let label = UILabel()
    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.text = "test"
        addSubview(label)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter value"
        textField.textAlignment = .right
        
        addSubview(textField)
        
        NSLayoutConstraint.activate([
        
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            label.heightAnchor.constraint(equalTo: heightAnchor),
            
            // Change widht
            textField.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 16.0),
            textField.widthAnchor.constraint(equalTo: widthAnchor, constant: -(label.frame.size.width + 30)),
            textField.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(title: String, value: String?) {
        label.text =  title
        textField.text = value
    }
}
