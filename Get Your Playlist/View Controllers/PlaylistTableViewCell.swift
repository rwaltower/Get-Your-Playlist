//
//  PlaylistCell.swift
//  Get Your Playlist
//
//  Created by Q. Nally on 11/26/18.
//  Copyright © 2018 Team 6. All rights reserved.
//
import UIKit

class PlaylistTableViewCell: UITableViewCell{
    @IBOutlet weak var playlistImage: UIImageVie
    @IBOutlet weak var playlistLabel: UILabel!
    
    var playlist: Playlist! {
        didSet {
            updateUI()
        }
    }
    
    func setPlaylist(playlist: Playlist){
        playlistImage.image = playlist.playlistImage
        playlistLabel.text = playlist.title
    }
}
