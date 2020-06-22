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
        
        let views = [label, textField]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemGray
        
        textField.placeholder = "Enter value"
        textField.textColor = .label
        textField.textAlignment = .right
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            stackView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
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
