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
        DropboxClientsManager.authorizeFromController(
            UIApplication.shared, controller: viewController, openURL: { (url: URL) -> Void in
        })
    }
    
    
    func uploadToDrobox(imageData: Data, path: String, imageName: String) {
        if let client = client {
            client.files.deleteV2(path: "/\(path)/\(imageName).jpg").response { (result, error) in
                if let error = error {
                    print("Error with dropbox:", error)
                } else {
                    client.files.upload(path: "/\(path)/\(imageName).jpg", input: imageData).response { (metadata, error) in
                        if let error = error {
                            print("Error with dropbox:", error)
                        }
                    }
                }
            }
        }
    }
    
    func getImage(path: String) {
        client?.files.download(path: "/Apps/Schematic Capture/7hjX1pHD1FN0ZaGStGde71uiGYa2.jpg")
            .response { response, error in
                if let response = response {
                    let responseMetadata = response.0
                    print(responseMetadata)
                    let fileContents = response.1
                    print(fileContents)
                } else if let error = error {
                    print("Error downloading the image from DropBox", error)
                }
        }
        .progress { progressData in
            print(progressData)
        }
    }
    
}
