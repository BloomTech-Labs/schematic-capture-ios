//
//  Style.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import Foundation
import UIKit

class Style {
    
    // Primary Colors
    static let toryBlue: UIColor = hexStringToUIColor(hex: "#1165A8")
    static let tarawera: UIColor = hexStringToUIColor(hex: "#072F50")
    static let anakiwa: UIColor = hexStringToUIColor(hex: "#8DCDFF")
    
    // Documentation Colors
    static let rose: UIColor = hexStringToUIColor(hex: "#FF005C")
    static let sunshade: UIColor = hexStringToUIColor(hex: "#FFA928")
    static let parisDaisy: UIColor = hexStringToUIColor(hex: "#FFF972")
    static let springGreen: UIColor = hexStringToUIColor(hex: "#23FF53")
    
    // Neutral Colors
    static let thunder: UIColor = hexStringToUIColor(hex: "#231F20")
    static let shipGray: UIColor = hexStringToUIColor(hex: "#424244")
    static let osloGray: UIColor = hexStringToUIColor(hex: "#939598")
    static let iron: UIColor = hexStringToUIColor(hex: "#D5D8DC")
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func styleTextField(_ textfield:UITextField) {
        DispatchQueue.main.async {
            // Create the bottom line
            let bottomLine = CALayer()
            
            bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 2)
            
            bottomLine.backgroundColor = hexStringToUIColor(hex: "#1165A8").cgColor
            
            // Remove border on text field
            textfield.borderStyle = .none
            
            // Add the line to the text field
            textfield.layer.addSublayer(bottomLine)
        }
    }
    
    static func styleFilledButton(_ button:UIButton) {
        DispatchQueue.main.async {
            button.backgroundColor = hexStringToUIColor(hex: "#1165A8")
            button.layer.cornerRadius = 2
            button.tintColor = UIColor.white
            button.titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 20)
        }
    }
    
    static func styleHollowButton(_ button:UIButton) {
        DispatchQueue.main.async {
            // Hollow rounded corner style
            button.layer.borderWidth = 2
            button.layer.borderColor = toryBlue.cgColor
            button.layer.cornerRadius = 3
            button.tintColor = tarawera
            button.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 20)
        }
    }
}
