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
    var titleLabel = UILabel()
    var searchBar = UISearchBar()
    
    weak var searchDelegate: SearchDelegate?
    
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
        addSubview(secondaryLabel)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.isHidden = true
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
            let date = CachedDateFormattingHelper.shared.formatTodayDate()
            updateViews("Welcome back \(value.first ?? "")", date, value.last ?? "")
        case .projects:
            searchBar.isHidden = true            
            updateViews(value.first ?? "", value[1], value.last ?? "")
        case .jobsheets:
            searchBar.isHidden = false
            updateViews(value.first ?? "", "", value.last ?? "")
        case .components:
            updateViews(value.first ?? "", "", value.last ?? "")
        case .componentDetails:
            break
        }
    }
    
    func updateViews(_ value: String, _ secondValue: String, _ title: String) {
        label.text = value
        titleLabel.text = title
        secondaryLabel.text = secondValue
        searchBar.placeholder = "Search for \(title)"
    }
}



// MARK: - UISearchBarDelegate
extension HeaderView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDelegate?.searchDidEnd(didChangeText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
