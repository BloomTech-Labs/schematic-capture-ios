//
//  ClientHeaderView.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/15/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ClientHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome back, \n Bob!"
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        addSubview(label)
        
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.sizeToFit()
        let date = CachedDateFormattingHelper.shared.formatTodayDate()
        dateLabel.text = date
        dateLabel.numberOfLines = 3
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .systemGray2
        
        addSubview(dateLabel)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Clients"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .systemGray
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 30.0),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            dateLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16.0),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -32.0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
}
