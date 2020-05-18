//
//  HeaderView.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/15/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit


enum ViewTypes: String {
    case clients
    case projects
    case jobsheets
    case jobsheetDetails
    case components
}



class HeaderView: UIView {
    
    var label = UILabel()
    var secondaryLabel = UILabel()
    var titleLabel = UILabel()
    var searchBar = UISearchBar()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        addSubview(label)
        
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.sizeToFit()
        secondaryLabel.numberOfLines = 3
        secondaryLabel.font = UIFont.systemFont(ofSize: 17)
        secondaryLabel.textAlignment = .center
        secondaryLabel.textColor = .systemGray2
        
        let date = CachedDateFormattingHelper.shared.formatTodayDate()
        secondaryLabel.text = date
        addSubview(secondaryLabel)
        
            
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        addSubview(searchBar)
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Clients"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .systemGray
        addSubview(titleLabel)
        
        
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 30.0),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16.0),
            secondaryLabel.widthAnchor.constraint(equalTo: widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -32.0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
            searchBar.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -24.0),
            searchBar.widthAnchor.constraint(equalTo: widthAnchor),
            searchBar.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setup(viewTypes: ViewTypes, value: [String]) {
        switch viewTypes {
        case .clients:
            searchBar.isHidden = true
            updateViews("Welcome back \(value.first ?? "")", value.last ?? "")
        case .projects:
            updateViews(value.first ?? "", value.last ?? "")
        case .jobsheets:
            print("Jobsheets")
        case .jobsheetDetails:
            print("Jobsheets details")
        case .components:
            print("Components")
        }
    }
    
    func updateViews(_ value: String, _ title: String) {
        label.text = value
        titleLabel.text = title
        searchBar.placeholder = "Search for \(title)"
    }
}
