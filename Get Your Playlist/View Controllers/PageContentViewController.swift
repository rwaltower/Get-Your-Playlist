//
//  PageContentViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/23/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PageContentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lblTitle: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnChoose: UIButton!
    

    var pageIndex: Int = 0
    var strTitle: String!
    var totalPages: Int = 0
    var genreData: [String] = []
    var artistData: [String] = []
    var allData: [String] = []
    var personalizationTopic: String!
    
    var personalizationViewController: PersonalizationViewController!
    
    let currentUser = PFUser.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self.view, action: Selector("endEditing:")))
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(userSwiped))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        personalizationTopic = personalizationViewController?.pageTitles[pageIndex]
        
        lblTitle.title = strTitle
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshChoices), name: NSNotification.Name(rawValue: "refreshTable"), object: nil)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
        
        if allData.isEmpty {
            cell.textLabel?.text = ""
        } else if allData.count < indexPath.row + 1 {
            cell.textLabel?.text = ""
        } else {
            cell.textLabel?.text = allData[indexPath.row]
        }
        
        print("alldata: \(allData)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath)
        
        let cellItem = cell!.textLabel?.text
        artistData = artistData.filter{$0 != cellItem }
        genreData = genreData.filter{$0 != cellItem }
        allData = allData.filter{$0 != cellItem }
        tableView.reloadData()

    }
    
    
    
    @objc func userSwiped(_ gesture: UISwipeGestureRecognizer) {
        print("current data: \(artistData) \(genreData)")
        if gesture.direction == .right {
            print("swiped right")
            
            /*do {
                if try isMood(data: personalizationTopic) {
                    let mood = PFObject.init(className: "user_has_moods")
                    mood["user_id"] = currentUser!
                    mood["mood_id"] = PersonaliaztionManager.personalizationManager.moodObjects[pageIndex]
                    mood["genres"] = genreData
                    mood["artists"] = artistData
                    mood.saveInBackground()
                } else if try isActivity(data: personalizationTopic) {
                    let activity = PFObject.init(className: "user_has_activities")
                    activity["user_id"] = currentUser!
                    activity["activity_id"] = PersonaliaztionManager.personalizationManager.activityObjects[pageIndex]
                    activity["genres"] = genreData
                    activity["artists"] = artistData
                    activity.saveInBackground()
                }
            } catch {
                print("Error determining mood or activity.")
            }*/
            
            if pageIndex == (totalPages - 1) {
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.present(homeViewController, animated: true, completion: nil)
                
            }
            
        }

    }
    
    func isMood(data: String) throws -> Bool {
        var isMood: Bool = false
        let query = PFQuery(className: "Moods")
        query.whereKey("name", equalTo: data)

        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
            if let error = error {

                print(error.localizedDescription)
            } else if object != nil {
                print("Is mood.")
                isMood = true
            }
        }
        
        return isMood
    }
    
    func isActivity(data: String) throws -> Bool {
        var isActivity: Bool = false
        let query = PFQuery(className: "Activities")
        query.whereKey("name", equalTo: data)
        query.getFirstObjectInBackground { (object: PFObject?, error: Error?) in
            if let error = error {

                print(error.localizedDescription)
            } else if object != nil {
                print("Is activity.")
                isActivity = true
            }
        }
        
        return isActivity
    }
    
    @objc func refreshChoices() {
        print("refresh")
        
        tableView.reloadData()
    }
    
    @IBAction func chooseButtonPressed(_ sender: UIButton) {
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        searchViewController.searchTitle = strTitle
        searchViewController.pageContentViewController = self
        
        self.present(searchViewController, animated: true)
    }
    
}
