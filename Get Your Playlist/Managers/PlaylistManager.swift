//
//  PlaylistManager.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/23/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import Parse

class PlaylistManager: NSObject {
    
    let currentUser = PFUser.current()
    
    var dataManager: DataManager!
    
    func createPlaylist(playlistData: Array<Any>) {
        var songs: [String] = []
        
        
        
    }
    
    func retrieveMoodData(myMood: String, completion: @escaping (_ moodArray: [[String]]? ) -> ()) {
        var moodArray: [[String]] = []
        let artistArray: [String] = []
        let genreArray: [String] = []

        moodArray.append(artistArray)
        moodArray.append(genreArray)
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
                        moodArray[0] = object!["artists"] as! [String]
                        moodArray[1] = object!["genres"] as! [String]
                    }
                    
                    completion(moodArray)
                }
            
            }
        }
        
    }
    
    func retrieveActivityData(myActivity: String, completion: @escaping (_ activityArray: [[String]]? ) -> ()) {
        var activityArray: [[String]] = []
        let artistArray: [String] = []
        let genreArray: [String] = []
        
        activityArray.append(artistArray)
        activityArray.append(genreArray)
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
                        activityArray[0] = object!["artists"] as! [String]
                        activityArray[1] = object!["genres"] as! [String]
                    }
                    
                    completion(activityArray)
                }
                
            }
        }
        
    }
 
}
