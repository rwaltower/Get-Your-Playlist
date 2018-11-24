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
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnNext: UIBarButtonItem!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var btnGenres: UIButton!
    @IBOutlet weak var btnArtists: UIButton!

    var pageIndex: Int = 0
    var strTitle: String!
    var totalPages: Int = 0
    var genreData: NSArray = NSArray()
    var artistData: NSArray = NSArray()
    var personalizationTopic: String!
    
    var personalizationViewController: PersonalizationViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        personalizationTopic = personalizationViewController?.pageTitles[pageIndex]
        
        lblTitle.text = strTitle
        
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
        do {
            if try isMood(data: personalizationTopic) {
                // TODO: Save choices to moods
            }
            
            if try isActivity(data: personalizationTopic) {
                // TODO: Save choices to activities
            }
        } catch {
            print("Error determining if mood or activity.")
        }
        
        
        
        if pageIndex == (totalPages - 1) {
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.present(homeViewController, animated: true, completion: nil)
            
        } else {
            personalizationViewController?.setViewControllers([personalizationViewController?.getViewControllerAtIndex(index: pageIndex - 1)] as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
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
    
}
