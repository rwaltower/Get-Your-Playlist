//
//  PlaylistViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/27/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MediaPlayer

class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    /// The instance of `AuthorizationManager` used for querying and requesting authorization status.
    var authorizationManager: AuthorizationManager!
    
    /// The instance of `MediaLibraryManager` that is used as a data source to display the contents of the application's playlist.
    var mediaLibraryManager: MediaLibraryManager!
    
    /// The instance of `MusicPlayerManager` that is used to trigger the playback of the application's playlist.
    var musicPlayerManager: MusicPlayerManager!
    
    @IBOutlet weak var playlistTableView: UITableView!
    @IBOutlet weak var lblPlaylistDetails: UILabel!
    @IBOutlet weak var btnPlay: UIBarButtonItem!
    @IBOutlet weak var btnClose: UIBarButtonItem!
    
    var currentPlaylistId: String = ""
    var currentPlaylistTitle: String = ""
    
    
    let currentUser = PFUser.current()
    
    var songsList: [MediaItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let query = PFQuery(className: "Playlists")
        query.whereKey("playlist_id", equalTo: currentPlaylistId)
        query.getFirstObjectInBackground{ (object: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.currentPlaylistTitle = object!["title"] as! String
                self.playlistTableView.reloadData()
             }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songsList.count > 0 {
            return songsList.count

        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        if songsList.count > 0 {
            cell.textLabel?.text = songsList[indexPath.row].name
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    @IBAction func pressPlay (_ sender: UIBarButtonItem) {
        
        let uuid = UUID(uuidString: self.currentPlaylistId)
        let playlistCreationMetaData = MPMediaPlaylistCreationMetadata(name: self.currentPlaylistTitle)
        MPMediaLibrary.default().getPlaylist(with: uuid!, creationMetadata: playlistCreationMetaData, completionHandler: { playlist, error in
            
            if let anError = error {
                print("\(anError)")
            }
            
            if error == nil {
                let mediaPlaylist = playlist
                
                self.musicPlayerManager.beginPlayback(itemCollection: mediaPlaylist!)
            }
            
            
        })
        
    }
}
