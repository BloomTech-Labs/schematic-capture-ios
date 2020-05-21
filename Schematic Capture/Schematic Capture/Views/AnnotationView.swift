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
        
        let imageView = UIImageView()
        imageView.tag = 1
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeShape(_:))))
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGesture:))))
        imageView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:))))
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:))))

        imageView.image = UIImage(systemName: shape!.rawValue)
        imageView.isHidden = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    @objc func removeShape(_ tapGesture: UITapGestureRecognizer) {
        if let viewWithTag = self.viewWithTag(tapGesture.view!.tag) {
            viewWithTag.removeFromSuperview()
        } else {
            print("No!")
        }
    }
    
    @objc func handlePan(panGesture: UIPanGestureRecognizer!) {
        
        if panGesture.state == .began {
            let locationInView = panGesture.location(in: superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
            layer.shadowOffset = CGSize(width: 0, height: 20)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 6
            return
        }
        if panGesture.state == .ended {
            dragStartPositionRelativeToCenter = nil
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 2
            return
        }
        let locationInView = panGesture.location(in: superview)
        panGesture.view?.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                                  y: locationInView.y - self.dragStartPositionRelativeToCenter!.y)
    }
    
    @objc func handleRotation( sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        let previousTransform = imageView.transform
        imageView.transform = previousTransform.rotated(by: rotation)
        sender.rotation = 0
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
}




