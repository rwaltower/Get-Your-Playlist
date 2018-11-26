//
//  CreatePlaylistViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/25/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit

class CreatePlaylistViewControllers: UIViewController {
    
    let appleMusicManager = AppleMusicManager()
    
    var mediaItems = [MediaItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleMusicManager.performAppleMusicCatalogSearch(with: "Lady Gaga",
                                                         completion: { [weak self] (searchResults, error) in
                                                            guard error == nil else {
                                                                
                                                                // Your application should handle these errors appropriately depending on the kind of error.
                                                                self?.mediaItems = []
                                                                
                                                                let alertController: UIAlertController
                                                                
                                                                guard let error = error as NSError?, let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? Error else {
                                                                    
                                                                    alertController = UIAlertController(title: "Error",
                                                                                                        message: "Encountered unexpected error.",
                                                                                                        preferredStyle: .alert)
                                                                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                                                    
                                                                    DispatchQueue.main.async {
                                                                        self?.present(alertController, animated: true, completion: nil)
                                                                    }
                                                                    
                                                                    return
                                                                }
                                                                
                                                                alertController = UIAlertController(title: "Error",
                                                                                                    message: underlyingError.localizedDescription,
                                                                                                    preferredStyle: .alert)
                                                                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                                                
                                                                DispatchQueue.main.async {
                                                                    self?.present(alertController, animated: true, completion: nil)
                                                                }
                                                                
                                                                return
                                                            }
                                                            
                                                            self?.mediaItems = searchResults
                                                            self?.refreshMediaItems()

        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshMediaItems() -> Void {
        print("Count: \(mediaItems.count)")
        print("Results: \(mediaItems[0])")

        print("Results: \(mediaItems[0].name)")
    }
    
    
}
