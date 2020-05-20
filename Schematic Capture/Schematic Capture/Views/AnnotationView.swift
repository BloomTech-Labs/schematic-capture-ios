//
//  AnnotationView.swift
//  
//
//  Created by Ufuk Türközü on 20.05.20.
//

import UIKit

class AnnotationView: UIView {
    
    var arrowButton = UIButton()
    var circleButton = UIButton()
    var boxButton = UIButton()
    var saveButton = UIButton()
    
    var colors = [UIColor.white, UIColor.black, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemOrange, UIColor.systemRed, UIColor.systemPink, UIColor.systemPurple]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        view.showsHorizontalScrollIndicator = false
        self.addSubview(view)
        return view
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        stackView.addArrangedSubview(arrowButton)
        stackView.addArrangedSubview(circleButton)
        stackView.addArrangedSubview(boxButton)
        
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16.0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            
        ])
        
    }
    
}

extension AnnotationView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        let color = colors[indexPath.row]
        cell.backgroundColor = color
        cell.layer.cornerRadius = cell.frame.size.width/2
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1.0
        
        return cell
    }

}



