//
//  AnnotationViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/20/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import PencilKit

class AnnotationViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var pencilFingerBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    var originalPhoto: UIImage?
    var component: Component?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let originalPhoto = originalPhoto else { return }
        imageView.image = originalPhoto
        
        canvasView.delegate = self
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        canvasView.overrideUserInterfaceStyle = .light
        
        if let window = parent?.view.window, let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            toolPicker.addObserver(self)
            canvasView.becomeFirstResponder()
        }
        
        pencilFingerBarButtonItem.title = "Finger"
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.rightBarButtonItems = [saveBarButtonItem, pencilFingerBarButtonItem]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX: CGFloat = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY: CGFloat = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        imageView.frame.size = CGSize(width: self.view.bounds.width * scrollView.zoomScale, height: self.view.bounds.height * scrollView.zoomScale)
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    /// Hide the home indicator, as it will affect latency.
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    @IBAction func gogglePencilFingerDrawing(_ sender: Any) {
        canvasView.allowsFingerDrawing.toggle()
        pencilFingerBarButtonItem.title = canvasView.allowsFingerDrawing ? "Finger" : "Pencil"
    }
    
    @IBAction func save(_ sender: Any) {
        guard let originalPhoto = originalPhoto,
            let component = component else { return }
        
        let annotationImage =  canvasView.drawing.image(from: imageView.bounds, scale: 1.0)
        let combinedImage = originalPhoto.mergeWith(topImage: annotationImage)
        
        guard let combinedImageJpegData = combinedImage.jpegData(compressionQuality: 1.0) else { return }
        
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            let photo = Photo(name: "\(component.componentId!).jpeg", imageData: combinedImageJpegData, context: context)
            component.photo = photo
            photo.ownedComponent = component
            CoreDataStack.shared.save(context: context)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension UIImage {
  func mergeWith(topImage: UIImage) -> UIImage {
    let bottomImage = self

    UIGraphicsBeginImageContext(size)

    let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
    bottomImage.draw(in: areaSize)

    topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

    let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return mergedImage
  }
}
