//
//  GeneralTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {
    
    
    var stackView = UIStackView()
    var firstLabel = UILabel()
    var secondLabel = UILabel()
    var thirdLabel = UILabel()
    var fourthLabel = UILabel()
    var regularImageView = UIImageView()
    
    var views = [UIView]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        firstLabel.textColor = .label
        firstLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        let regularFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        secondLabel.textColor = .label
        secondLabel.font = regularFont
        
        thirdLabel.textColor = .label
        thirdLabel.font = regularFont
        
        fourthLabel.textColor = .label
        fourthLabel.font = regularFont
        
        regularImageView.contentMode = .scaleAspectFit
        regularImageView.backgroundColor = .red
        
        
        views = [firstLabel, secondLabel, thirdLabel, fourthLabel, regularImageView]
        
        stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40.0),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(entityName: EntityNames, value: Any) {
        switch entityName {
        case .client:
            guard let client = value as? Client else { return }
            firstLabel.text = client.companyName
            secondLabel.text = "\(client.projects!.count) projects"
            regularImageView.image = UIImage(systemName: "envelope")
            self.stackView.removeArrangedSubview(thirdLabel)
            self.stackView.removeArrangedSubview(fourthLabel)
        case .project:
            guard let project = value as? Project else { return }
            firstLabel.textColor = .systemBlue
            firstLabel.text = project.name
            if project.completed == true {
                secondLabel.text = "Completed"
            } else {
                secondLabel.text = "Incompleted"
            }
            thirdLabel.text = "Kerby Jean"
            fourthLabel.text = "6/3/2020"
            
            self.stackView.removeArrangedSubview(regularImageView)
        case .jobSheet:
            guard let jobsheet = value as? JobSheet else { return }
            firstLabel.textColor = .systemBlue
            firstLabel.text = jobsheet.name
            secondLabel.text = "Kerby"
            thirdLabel.text = "Speed control"
            fourthLabel.text = "15 Parts"
            self.stackView.removeArrangedSubview(regularImageView)

        case .component:
            guard let component = value as? Component else { return }
            firstLabel.textColor = .systemBlue
            firstLabel.text = component.componentApplication
            secondLabel.text = "Kerby"
            thirdLabel.text = "Speed control"
            fourthLabel.text = "15 Parts"
            self.stackView.removeArrangedSubview(regularImageView)
        }
    }
}
