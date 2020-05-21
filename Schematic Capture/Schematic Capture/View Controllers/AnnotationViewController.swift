//
//  AnnotationViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/21/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

enum Shapes: String {
    case circle = "circle"
    case arrow = "arrow.left"
    case square = "square"
}

class AnnotationViewController: UIViewController {
    
    var imageView = UIImageView()
    var annotationView = AnnotationView()
    
    var colors = [UIColor.white, UIColor.black, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemOrange, UIColor.systemRed, UIColor.systemPink, UIColor.systemPurple]
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = 30
        let cellCount = self.colors.count
        let totalCellWidth = width * cellCount
        let totalSpacingWidth = 10 * (cellCount - 1)

        let leftInset = (self.view.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        self.view.addSubview(view)
        return view
    }()
    
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        view.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        view.addSubview(collectionView)
        
        
        // Toolbar setup
        var items = [UIBarButtonItem]()
        
        let circleButton = UIBarButtonItem(image: UIImage(systemName: "circle"), style: .done, target: self, action: #selector(action(_:)))
        circleButton.tag = 0
        
        let arrowButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(action(_:)))
        arrowButton.tag = 1
        
        let squareButton = UIBarButtonItem(image: UIImage(systemName: "square"), style: .done, target: self, action: #selector(action(_:)))
        squareButton.tag = 2
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(action(_:)))
        doneButton.tag = 3
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(circleButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(arrowButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(squareButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(doneButton)
        
        self.navigationController?.toolbar.barTintColor = .black
        self.navigationController?.toolbar.tintColor = .white
        self.toolbarItems = items
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -100),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 60.0),
        ])
    }
    
    @objc func action(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            annotationView.shape = Shapes.circle
        case 1:
            annotationView.shape = Shapes.arrow
        case 2:
            annotationView.shape = Shapes.square
        case 3:
            self.navigationController?.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}

extension AnnotationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        let color = colors[indexPath.row]
        cell.backgroundColor = color
        cell.layer.cornerRadius = cell.frame.size.width/2
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1.0
        return cell
    }
}
