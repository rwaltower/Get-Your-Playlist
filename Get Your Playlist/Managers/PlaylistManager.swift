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
    
    func createPlaylist(playlistData: Array<Any>) {
        let playlistMood = playlistData[0]
        let playlistActivity = playlistData[1]
        let playlistDuration = playlistData[2]
        do {
            let moodData = try retrieveMoodData(myMood: playlistMood as! String)
            
        } catch {
            print("Error retrieving mood data")
        }
        
        do {
            let activityData = try retrieveActivityData(myActivity: playlistActivity as! String)
        } catch {
            print("Error retrieving activity data")
        }
        
        
        
    }
    
    func retrieveMoodData(myMood: String) throws -> Array<Any> {
        var moodArray: Array<Any> = []
            
        let query = PFQuery(className: "Moods")
        query.whereKey("name", equalTo:myMood)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                print("Successfully retrieved mood.")
                // Do something with the found objects
                for object in objects {
                    moodArray.append(contentsOf: [object["genres"], object["artists"]])
                }
            }
        }
        
        return moodArray
    }
    
    func retrieveActivityData(myActivity: String) throws -> Array<Any> {
        var activityArray: Array<Any> = []
        
        let query = PFQuery(className: "Activities")
        query.whereKey("name", equalTo:myActivity)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                print("Successfully retrieved mood.")
                // Do something with the found objects
                for object in objects {
                    activityArray.append(contentsOf: [object["genres"], object["artists"]])
                }
            }
        }
        
        return activityArray
    }
    
    func retrieveSongs(artistData: Array<Any>, genreData: Array<Any>) throws -> Array<Any> {
        var songData: Array<Any> = []
        var artistIds: Array<Any> = []
        var genreIds: Array<Any> = []
        let artistQuery = PFQuery(className: "Artists")

        for artist in artistData {
            artistQuery.whereKey("name", equalTo: artist)
            artistQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    print("Successfully retrieved artist.")
                    // Do something with the found objects
                    for object in objects {
                        
                    }
                }
                
            }
        }
        return songData
    }
}
