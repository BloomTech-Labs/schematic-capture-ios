//
//  TitleView.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/18/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class TitleView: UIView {
    
    var firstLabel = UILabel()
    var secondLabel = UILabel()
    var thirdLabel = UILabel()
    var fourthLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLabel.font = font
        firstLabel.textAlignment = .center
        firstLabel.textColor = .systemGray2
        addSubview(firstLabel)
        
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.font = font
        secondLabel.textAlignment = .center
        secondLabel.textColor = .systemGray2
        addSubview(secondLabel)
        
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.font = font
        thirdLabel.textAlignment = .center
        thirdLabel.textColor = .systemGray2
        addSubview(thirdLabel)
        
        fourthLabel.translatesAutoresizingMaskIntoConstraints = false
        fourthLabel.font = font
        fourthLabel.textAlignment = .center
        fourthLabel.textColor = .systemGray2
        addSubview(fourthLabel)
        
        let views = [firstLabel, secondLabel, thirdLabel, fourthLabel]
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32.0),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    func updateViews(values: [String]) {
        firstLabel.text = values.first
        secondLabel.text = values[1]
        thirdLabel.text = values[2]
        fourthLabel.text = values[3]
    }
}
