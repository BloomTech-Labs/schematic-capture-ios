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
    var indexLabel = UILabel()
    
    var views = [UIView]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        indexLabel.textColor = .label
        indexLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        indexLabel.backgroundColor = .red
        
        firstLabel.textColor = .label
        firstLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
<<<<<<< HEAD
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
=======
        firstLabel.backgroundColor = .red
>>>>>>> e4479540bbaf37f2636012ef15de2c4196acd077
        
        let regularFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        secondLabel.textColor = .label
        secondLabel.font = regularFont
        secondLabel.textAlignment = .center
        
        thirdLabel.textColor = .label
        thirdLabel.font = regularFont
        
        fourthLabel.textColor = .label
        fourthLabel.font = regularFont
        fourthLabel.textAlignment = .right
        fourthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        regularImageView.contentMode = .scaleAspectFit
<<<<<<< HEAD
        regularImageView.image = UIImage(systemName: "envelope")
        regularImageView.translatesAutoresizingMaskIntoConstraints = false
        
        views = [firstLabel, secondLabel, thirdLabel, fourthLabel, regularImageView]
        
        stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            firstLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            regularImageView.heightAnchor.constraint(equalToConstant: 32.0),
            regularImageView.widthAnchor.constraint(equalToConstant: 32.0),
            regularImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            regularImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.0),
            
            fourthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -32.0),
=======
        regularImageView.backgroundColor = .red
//        regularImageView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(regularImageView)
        
        views = [indexLabel, firstLabel, secondLabel, thirdLabel, fourthLabel, regularImageView]
        
        stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            firstLabel.widthAnchor.constraint(equalToConstant: 96),
            
            regularImageView.heightAnchor.constraint(equalToConstant: 40),
            regularImageView.widthAnchor.constraint(equalToConstant: 40),
            regularImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            //regularImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
>>>>>>> e4479540bbaf37f2636012ef15de2c4196acd077
            
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -40.0),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(entityName: EntityNames, value: Any) {
        print("CONFIGURE!")
        switch entityName {
        case .client:
            guard let client = value as? Client else { return }
            firstLabel.text = client.companyName
<<<<<<< HEAD
            secondLabel.text = "\(client.projects!.count) projects"
            self.stackView.removeArrangedSubview(thirdLabel)
            self.stackView.removeArrangedSubview(fourthLabel)
=======
            fourthLabel.text = "\(client.projects!.count) projects"
            regularImageView.isHidden = true
            indexLabel.isHidden = true
>>>>>>> e4479540bbaf37f2636012ef15de2c4196acd077
        case .project:
            guard let project = value as? Project else { return }
            firstLabel.textColor = .systemBlue
            firstLabel.text = project.name
            if project.completed == true {
                secondLabel.text = "Completed"
            } else {
                secondLabel.text = "Incompleted"
            }
            thirdLabel.text = "Kerby Jeanjeanje"
            fourthLabel.text = "6/3/2020"
<<<<<<< HEAD
            self.regularImageView.isHidden = true
=======
            regularImageView.isHidden = true
            indexLabel.isHidden = true
>>>>>>> e4479540bbaf37f2636012ef15de2c4196acd077
        case .jobSheet:
            guard let jobsheet = value as? JobSheet else { return }
            firstLabel.textColor = .systemBlue
            firstLabel.text = jobsheet.name
            secondLabel.text = "Kerby Jeanjeanje"
            thirdLabel.text = "Speed control"
            fourthLabel.text = "15"
            regularImageView.isHidden = true
            indexLabel.isHidden = true
        case .component:
            guard let component = value as? Component else { return }
            print("PROJECT IS BEING CONFIGURE: ", component.componentApplication)
            indexLabel.text = String(component.id)
            firstLabel.textColor = .systemBlue
            firstLabel.text = component.descriptions
            secondLabel.text = "15"
            thirdLabel.text = "Speed control"
            regularImageView.isHidden = false
        }
    }
}
