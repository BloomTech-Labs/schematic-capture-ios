//
//  HeaderView.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/15/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

protocol SearchDelegate: AnyObject {
    func searchDidEnd(didChangeText: String)
}

class HeaderView: UIView {
    
    var label = UILabel()
    var secondaryLabel = UILabel()
    var imageView = UIImageView()
    var button = UIButton()
    var stackView: UIStackView!
    
    weak var searchDelegate: SearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)

        secondaryLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        secondaryLabel.textColor = .systemGray
        secondaryLabel.isUserInteractionEnabled = true
        
        button.setImage(UIImage(systemName: "arrow.up.right"), for: .normal)
        button.isHidden = true
        addSubview(button)
           
        stackView = UIStackView(arrangedSubviews: [secondaryLabel, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        let secondStackView = UIStackView(arrangedSubviews: [label, stackView])
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(secondStackView)
        secondStackView.spacing = 16
        secondStackView.axis = .vertical
        secondStackView.alignment = .center
        secondStackView.distribution = .fillProportionally
        
        NSLayoutConstraint.activate([
//            label.widthAnchor.constraint(equalTo: widthAnchor),
//            label.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            
            secondStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            secondStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    func updateViews(_ value: String, _ secondValue: String, _ title: String) {
        label.text = value
        secondaryLabel.text = secondValue
    }
    
    func showButton(text: String)  {
        secondaryLabel.text = text
        secondaryLabel.isHidden = false
        secondaryLabel.textColor = .systemBlue
        button.isHidden = false
    }
}
