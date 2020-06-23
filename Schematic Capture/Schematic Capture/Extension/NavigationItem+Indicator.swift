//
//  NavigationItem+Indicator.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/22/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func addActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            activityIndicator.style = .gray
        }
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }
    
    func removeActivityIndicator(_ title: String?, _ selector: Selector) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        self.setRightBarButton(button, animated: true)
    }
}
