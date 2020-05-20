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
    var thirdLabel = UILabel()
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
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.font = UIFont.systemFont(ofSize: 20)
        thirdLabel.textAlignment = .center
        thirdLabel.textColor = .label
        addSubview(thirdLabel)
        
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.font = UIFont.systemFont(ofSize: 16)
        secondaryLabel.textAlignment = .center
        secondaryLabel.textColor = .systemGray2
        addSubview(secondaryLabel)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.isHidden = true
        //addSubview(searchBar)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Clients"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .systemGray
        addSubview(titleLabel)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(thirdLabel)
        stackView.addArrangedSubview(secondaryLabel)
        stackView.addArrangedSubview(searchBar)
        stackView.setCustomSpacing(16, after: secondaryLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor)
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
            updateViews(value.first ?? "", value[1], value.last ?? "")
        case .components:
            updateViews(value.first ?? "", value[1], value.last ?? "")
            thirdLabel.text = "Component list"
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
