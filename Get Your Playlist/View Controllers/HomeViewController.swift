//
//  HomeViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/20/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnCreatePlaylist: UIButton!
    @IBOutlet weak var playlistsTable: UITableView!
    
    var userPlaylists: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let currentUser = PFUser.current()

        let query = PFQuery(className: "user_has_playlists")
        query.whereKey("user_id", equalTo: currentUser!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {

                print(error.localizedDescription)
            } else if let objects = objects {

                print("Successfully retrieved user playlists.")

                for object in objects {
                    self.userPlaylists.append(object["name"] as! String)
                }
            }

            self.playlistsTable.reloadData()
        }

    }
}

