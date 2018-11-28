//
//  PlaylistManager.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/23/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import Parse
import UIKit
import StoreKit
import MediaPlayer

@objcMembers
class PlaylistManager {
    
    let currentUser = PFUser.current()
    
    var dataManager: DataManager!
    
    let appleMusicManager = AppleMusicManager()
    
    var mediaItems = [MediaItem]()
    
    func createPlaylist(data: [String], playlistName: String) -> String {
        let uuid = UUID()
        MPMediaLibrary.default().getPlaylist(with: uuid, creationMetadata: MPMediaPlaylistCreationMetadata(name: playlistName), completionHandler: { playlist, error in
            
            if let anError = error {
                print("\(anError)")
            }
            
            if error == nil {
                
                
                for song_id in data {
                    playlist!.addItem(withProductID: song_id)
                }
            }
            
            
        })
        
        let playlistId = uuid.uuidString
        
        return playlistId
    }
    
    func retrieveMoodData(myMood: String, completion: @escaping (_ moodArray: [String]? ) -> ()) {
        var moodArray: [String] = []
        
        let query = PFQuery(className: "Moods")
        query.whereKey("name", equalTo:myMood)
        query.getFirstObjectInBackground{ (object: PFObject?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if object != nil {
                let query = PFQuery(className: "user_has_moods")
                query.whereKey("user_id", equalTo: self.currentUser!)
                query.whereKey("mood_id", equalTo: object!)
                query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if object != nil {
                        moodArray += object!["artists"] as! [String]
                        moodArray += object!["genres"] as! [String]
                    }
                    
                    completion(moodArray)
                }
            
            }
        }
        
    }
    
    func retrieveActivityData(myActivity: String, completion: @escaping (_ activityArray: [String]? ) -> ()) {
        var activityArray: [String] = []
        
        let query = PFQuery(className: "Activities")
        query.whereKey("name", equalTo:myActivity)
        query.getFirstObjectInBackground{ (object: PFObject?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if object != nil {
                let query = PFQuery(className: "user_has_activities")
                query.whereKey("user_id", equalTo: self.currentUser!)
                query.whereKey("activity_id", equalTo: object!)
                query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if object != nil {
                        activityArray += object!["artists"] as! [String]
                        activityArray += object!["genres"] as! [String]
                    }
                    
                    completion(activityArray)
                }
                
            }
        }
        
    }
 
}
