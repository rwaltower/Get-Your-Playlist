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

class PageContentViewController: UIViewController {
    @IBOutlet weak var lblTitle: UINavigationItem!
    
    @IBOutlet weak var btnNext: UIBarButtonItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var collectionChoices: UICollectionView!
    
    @IBOutlet weak var btnChoose: UIButton!
    

    var pageIndex: Int = 0
    var strTitle: String!
    var totalPages: Int = 0
    var genreData: NSArray = NSArray()
    var artistData: NSArray = NSArray()
    var personalizationTopic: String!
    
    var personalizationViewController: PersonalizationViewController?
    
    var currentUser = PFUser.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalizationTopic = personalizationViewController?.pageTitles[pageIndex]
        
        lblTitle.title = strTitle
        
        if pageIndex == 0 {
            btnBack.isEnabled = false
        } else {
            btnBack.isEnabled = true
        }
        
        if pageIndex == (totalPages - 1) {
            btnNext.title = "Done"
        }

    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
       
        print("pressed next")
        
        
        if pageIndex == (totalPages - 1) {
            print("last page")
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.present(homeViewController, animated: true, completion: nil)
            
        } else {
            print("next page")
            personalizationViewController?.setViewControllers([personalizationViewController?.getViewControllerAtIndex(index: pageIndex + 1)] as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        print("pressed back")
 personalizationViewController?.setViewControllers([personalizationViewController?.getViewControllerAtIndex(index: pageIndex - 1)] as? [UIViewController], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: nil)
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
    
    @IBAction func chooseButtonPressed(_ sender: UIButton) {
        // TODO: Initlize search view controller
        
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchViewController.searchTitle = strTitle
        
        self.present(searchViewController, animated: true)
    }
    
}
