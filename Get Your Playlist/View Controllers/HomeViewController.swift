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
    // testing playlist cells
    var playlists: [Playlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let currentUser = PFUser.current()
//
//        let query = PFQuery(className: "user_has_playlists")
//        query.whereKey("user_id", equalTo: currentUser!)
//        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
//            if let error = error {
//
//                print(error.localizedDescription)
//            } else if let objects = objects {
//
//                print("Successfully retrieved user playlists.")
//
//                for object in objects {
//                    self.userPlaylists.append(object["name"] as! String)
//                }
//            }
//
//            self.playlistsTable.reloadData()
//        }
        
        playlistsTable.delegate = self
        playlistsTable.dataSource = self

    }
    
    func createDummyPlaylists() -> [Playlist] {
        var tempPlaylists: [Playlist] = []
        
        let p1 = Playlist(title: "Chill", playlistImage: UIImage(named: "j_cole"))
        let p2 = Playlist(title: "Happy Go Lucky", playlistImage: UIImage(named: "beatles"))
        
        tempPlaylists.append(p1)
        tempPlaylists.append(p2)
        
        return tempPlaylists
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let playlist = playlists[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell") as! PlaylistTableViewCell
        
        cell.setPlaylist(playlist: playlist)
        
        return cell
    }
}

