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
    
    var titleView = TitleView()
    
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
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        addSubview(label)
        
        thirdLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdLabel.font = UIFont.systemFont(ofSize: 20)
        thirdLabel.textAlignment = .center
        thirdLabel.textColor = .label
        addSubview(thirdLabel)
        
        secondaryLabel.font = UIFont.systemFont(ofSize: 13)
        secondaryLabel.textAlignment = .center
        secondaryLabel.textColor = .systemGray
        secondaryLabel.sizeToFit()
        addSubview(secondaryLabel)
        
        let stackView = UIStackView(arrangedSubviews: [label, secondaryLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
//        addSubview(titleView)
        
        NSLayoutConstraint.activate([
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),

//            titleView.widthAnchor.constraint(equalTo: widthAnchor),
//            titleView.heightAnchor.constraint(equalToConstant: 50),
//            titleView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
