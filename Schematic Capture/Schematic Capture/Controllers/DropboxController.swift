//
//  DropboxController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/26/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import SwiftyDropbox

class DropboxController {
    
    var path = [String]()
    
    var client: DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }
    
    var selectedComponentRow: Int {
        get {
            let row = UserDefaults.standard.integer(forKey: .componentRow)
            return row
        }
        set {
            UserDefaults.standard.removeObject(forKey: .componentRow)
            UserDefaults.standard.synchronize()
            return UserDefaults.standard.set(newValue, forKey: .componentRow)

        }
    }
    
    func authorizeClient(viewController: UIViewController) {
        DropboxClientsManager.authorizeFromController(
            UIApplication.shared, controller: viewController, openURL: { (url: URL) -> Void in
        })
    }
    
    func uploadToDropbox(imageData: Data, path: String, imageName: String) {
        
        if let client = client {
            client.files.upload(path: "/\(path)/\(imageName).jpg", input: imageData).response { (metadata, error) in
                if let error = error {
                    print("Error uploading with dropbox:", error)
                }
            }
        }
    }
    
    func updateDropbox(imageData: Data, path: [String], imageName: String) {
        print("DROPBOX")
        let fullpath = path.joined(separator: "/")
        if let client = client {
            client.files.deleteV2(path: "/\(fullpath)/\(imageName).jpg").response { (result, error) in
                if let error = error {
                    print("Error deleting with dropbox:", error)
                    self.uploadToDropbox(imageData: imageData, path: fullpath, imageName: imageName)
                } else {
                    self.uploadToDropbox(imageData: imageData, path: fullpath, imageName: imageName)
                }
            }
        }
    }
}
