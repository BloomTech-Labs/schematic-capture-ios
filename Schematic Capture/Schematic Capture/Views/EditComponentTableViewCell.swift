//
//  EditComponentTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/18/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class EditComponentTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .systemGray
        addSubview(titleLabel)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter value"
        textField.textColor = .label
        addSubview(textField)
        
        NSLayoutConstraint.activate([
        
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor),
            
            textField.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 8.0),
            textField.widthAnchor.constraint(equalTo: widthAnchor, constant: -titleLabel.frame.size.width)
        ])
    }
    
    func updateViews(title: String, value: String) {
        
        titleLabel.text = title
        textField.text = value
    }
}
