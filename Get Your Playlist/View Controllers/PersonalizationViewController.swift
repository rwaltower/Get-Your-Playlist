//
//  PersonalizationViewController.swift
//  Get Your Playlist
//
//  Created by Radasia Waltower on 11/23/18.
//  Copyright © 2018 Team 6. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PersonalizationViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageTitles = [] as [String]
    let currentUser = PFUser.current() as PFUser?

    var moods = [] as [PFObject]
    var activities = [] as [PFObject]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let moodsQuery = PFQuery(className: "Moods")
        moodsQuery.whereKeyExists("name")
        moodsQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {

                print(error.localizedDescription)
            } else if let objects = objects {
                self.moods = objects
                print("Successfully retrieved moods.")

                for object in objects {
                    self.pageTitles.append(object["name"] as! String)
                }
            }
        }
        
        let activitiesQuery = PFQuery(className: "Activities")
        activitiesQuery.whereKeyExists("name")
        activitiesQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {

                print(error.localizedDescription)
            } else if let objects = objects {
                self.activities = objects
                print("Successfully retrieved activities.")

                for object in objects {
                    self.pageTitles.append(object["name"] as! String)
                }
            } else {
                
            }
        }
        
        self.dataSource = self
        
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore
        viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1;
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        index += 1;
        if (index == pageTitles.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
    
    // MARK:- Other Methods
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        pageContentViewController.strTitle = "When I'm \(pageTitles[index])..."
        pageContentViewController.pageIndex = index
        pageContentViewController.totalPages = pageTitles.count
        
        return pageContentViewController
    }
    
}
