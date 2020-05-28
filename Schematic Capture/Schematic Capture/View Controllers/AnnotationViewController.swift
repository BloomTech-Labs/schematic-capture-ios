//
//  AnnotationViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/21/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

protocol ImageDoneEditingDelegate: AnyObject {
    func ImageDoneEditing(image: UIImage?)
    
}

class AnnotationViewController: UIViewController {
    
    var annotationView = AnnotationView()
    
    var component: Component?
    
    var colors = [UIColor.white, UIColor.black, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemYellow, UIColor.systemOrange, UIColor.systemRed, UIColor.systemPink, UIColor.systemPurple]
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = 30
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: width, bottom: 0, right: 0)
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
            annotationView.image = image
        }
    }
    
    weak var imageDoneEditingDelegate: ImageDoneEditingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        view.backgroundColor = .black
        
        view.addSubview(annotationView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        view.addSubview(collectionView)
        
        // Toolbar setup
        var items = [UIBarButtonItem]()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(action))
        cancelButton.tag = 0
        
        let circleButton = UIBarButtonItem(image: UIImage(systemName: "circle"), style: .done, target: self, action: #selector(action(_:)))
        circleButton.tag = 1
        
        let arrowButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(action(_:)))
        arrowButton.tag = 2
        
        let squareButton = UIBarButtonItem(image: UIImage(systemName: "square"), style: .done, target: self, action: #selector(action(_:)))
        squareButton.tag = 3
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(action(_:)))
        doneButton.tag = 4
        
        items.append(cancelButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(circleButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(arrowButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(squareButton)
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(doneButton)
        
        self.toolbarItems = items
        
        self.navigationController?.toolbar.barTintColor = .black
        self.navigationController?.toolbar.tintColor = .white
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        
        NSLayoutConstraint.activate([
            
            annotationView.topAnchor.constraint(equalTo: view.topAnchor),
            annotationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            annotationView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -60.0),
            
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 60.0),
        ])
    }
    
    func captureScreen() {
       _ = image(with: annotationView)
    }
    
    func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            return image
        }
        return nil
    }
    
    @objc func action(_ sender: UIBarButtonItem) {
        switch sender.tag {
            case 0:
                self.navigationController?.dismiss(animated: true, completion: nil)
            case 1:
                annotationView.shape = Shapes.circle
            case 2:
                annotationView.shape = Shapes.arrow
            case 3:
                annotationView.shape = Shapes.square
            case 4:
                captureScreen()
                self.navigationController?.dismiss(animated: true, completion: {
                    self.imageDoneEditingDelegate?.ImageDoneEditing(image: self.annotationView.image)
                    
                })
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let color = colors[indexPath.row]
        annotationView.color = color
        //        self.navigationController?.toolbar.tintColor = color
    }
}
