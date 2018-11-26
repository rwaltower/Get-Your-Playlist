//
//  PersonalizationManager.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/23/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import Parse

class PersonaliaztionManager: NSObject {
    
    static let personalizationManager = PersonaliaztionManager()
    
    
    
    func getPersonalizationPageTitles(completion: @escaping (_ titles: [String]?, _ moodObjects: [PFObject], _ activityObjects: [PFObject])->()) {
        var moodObjects: [PFObject] = []
        var activityObjects: [PFObject] = []
        var titles: [String] = []
        let moodsQuery = PFQuery(className: "Moods")
        moodsQuery.whereKeyExists("name")
        moodsQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                
                print(error.localizedDescription)
            } else if let objects = objects {
                moodObjects = objects
                print("Successfully retrieved moods.")
                
                for object in objects {
                    
                    titles.append(object["name"] as! String)
                }
            }
            let activitiesQuery = PFQuery(className: "Activities")
            activitiesQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    
                    print(error.localizedDescription)
                } else if let objects = objects {
                    activityObjects = objects
                    print("Successfully retrieved activities.")
                    
                    for object in objects {
                        titles.append(object["name"] as! String)
                    }
                }
                
                completion(titles, moodObjects, activityObjects)
            }
        }
        
    }
    
}
