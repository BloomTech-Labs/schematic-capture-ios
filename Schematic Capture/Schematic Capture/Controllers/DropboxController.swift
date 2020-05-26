//
//  DropboxController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/26/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import SwiftyDropbox

class DropboxController {
    
    var client: DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }
    
    func authorizeClient(viewController: UIViewController) {
        if client == nil {
            DropboxClientsManager.authorizeFromController(
                UIApplication.shared, controller: viewController, openURL: { (url: URL) -> Void in
            })
        }
    }
    
    func getImage(imageName: String, completion: @escaping (UIImage, NetworkingError) -> ()) {
        // Get Image from dropbox
        
        // Download to Data
        client?.files.listFolder(path: "/AlloyTest/").response { response, error in
            if let response = response {
                let entries = response.entries
                print("ENTRIES:", entries)
            } else if let error = error {
                print(error)
            }
        }
    }
}
