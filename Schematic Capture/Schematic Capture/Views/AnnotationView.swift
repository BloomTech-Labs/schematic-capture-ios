//
//  AnnotationView.swift
//  
//
//  Created by Ufuk Türközü on 20.05.20.
//

import UIKit

class AnnotationView: UIView {
    
    var imageView = UIImageView()
    var annotateImageView = UIImageView()
    
    var views = [UIImageView]()
    
    var selectedShape: UIImageView?
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var shape: Shapes? {
        didSet {
            addShape(shape: shape)
        }
    }
    
    var color: UIColor? {
        didSet {
            guard let currentImage = selectedShape?.image else { return }
            let image = currentImage.withTintColor(color!, renderingMode: .alwaysOriginal)
            self.selectedShape?.image = image
        }
    }
    
    var dragStartPositionRelativeToCenter : CGPoint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    func addShape(shape: Shapes?) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.layer.position.y = layer.position.y
        imageView.layer.position.x = layer.position.x
        
        imageView.tag = self.subviews.count + 1
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        
        let indexTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToFront(_:)))
        indexTapGesture.numberOfTapsRequired = 1
        
        let removeGesture = UITapGestureRecognizer(target: self, action: #selector(removeShape(_:)))
        removeGesture.numberOfTapsRequired = 2
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        
        panGesture.delegate = self
        rotationGesture.delegate = self
        pinchGesture.delegate = self
        
        imageView.addGestureRecognizer(indexTapGesture)
        imageView.addGestureRecognizer(removeGesture)
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(rotationGesture)
        imageView.addGestureRecognizer(pinchGesture)
        
        imageView.image = UIImage(systemName: shape!.rawValue)
        imageView.isHidden = false
        
        if !self.subviews.contains(imageView) {
            self.selectedShape = imageView
            addSubview(imageView)
        }
    }
    
    @objc func moveToFront(_ tapGesture: UITapGestureRecognizer) {
        if let view = self.viewWithTag(tapGesture.view!.tag) {
            bringSubviewToFront(view)
        }
    }
    
    @objc func removeShape(_ tapGesture: UITapGestureRecognizer) {
        if let viewWithTag = self.viewWithTag(tapGesture.view!.tag) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state  {
        case .began, .changed:
            let translation = gestureRecognizer.translation(in: self)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        case .ended:
            if let view = gestureRecognizer.view as? UIImageView {
                self.selectedShape = view
                bringSubviewToFront(view)
            }
        default:
            break
        }
    }
    
    @objc func handleRotation(_ sender: UIRotationGestureRecognizer) {
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
}

// MARK: - UIGestureRecognizerDelegate
extension AnnotationView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}




