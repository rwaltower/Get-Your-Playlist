//
//  PlaylistsViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/28/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MediaPlayer

class PlaylistsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var musicPlayerManager: MusicPlayerManager!

    var userPlaylists: [String] = []
    var playlistIds: [UUID] = []
    
    @IBOutlet weak var playlistsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("can't find playlists")
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
                
                let query = PFQuery(className: "Playlist")
                query.whereKey("title", containedIn: self.userPlaylists)
                query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) in
                    if let error = error {
                        // The query failed
                        print(error.localizedDescription)
                    } else {
                        for object in objects! {
                            self.playlistIds.append(UUID(uuidString: object["uuid"] as! String)!)
                        }
                        
                        self.playlistsTable.reloadData()
                    }
                    
                }
                
                
                
                
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.identifier,
                                                       for: indexPath) as? PlaylistTableViewCell else {
                                                        return UITableViewCell()
        }
        if userPlaylists.count < 0 {
            cell.lblPlaylistTitle?.text = ""
            cell.btnPlay?.isHidden = true
        } else {
            cell.lblPlaylistTitle?.text = userPlaylists[indexPath.row]
            cell.btnPlay?.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userPlaylists.count > 0 {
            let uuid = UUID()
            MPMediaLibrary.default().getPlaylist(with: uuid, creationMetadata: MPMediaPlaylistCreationMetadata(name: userPlaylists[indexPath.row]), completionHandler: { playlist, error in
            
                if let anError = error {
                    print("\(anError)")
                }
            
                if error == nil {
                
                    self.musicPlayerManager.beginPlayback(itemCollection: playlist!)

            }
            
            
            })
        }
    }
}
