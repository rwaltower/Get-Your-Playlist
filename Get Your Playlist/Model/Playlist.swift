//
//  playlist.swift
//  Get Your Playlist
//
//  Created by Q. Nally on 11/23/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit

class Playlist
{
    var title = ""
    var playlistImage : UIImage
    
    init(title: String, playlistImage: UIImage) {
        self.title = title
        self.playlistImage = playlistImage
    }
}
