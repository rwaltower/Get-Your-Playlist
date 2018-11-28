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
    
    var pageTitles: [String] = []
    let currentUser: PFUser = PFUser.current()!

    var moods: [PFObject] = []
    var activities: [PFObject] = []
    
    let appleMusicManager = AppleMusicManager()
    
    var mediaItems: [[MediaItem]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing(_:))))
        
         PersonaliaztionManager.personalizationManager.getPersonalizationPageTitles(completion: {(titles, moods, activities) in
            self.pageTitles = titles!
            self.dataSource = self
            
            self.setViewControllers([self.getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        })
    
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
        
        if index > 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "submitChoices"), object: nil)
        }
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController

        pageContentViewController.strTitle = "When I'm \(pageTitles[index])..."
        pageContentViewController.pageIndex = index
        pageContentViewController.totalPages = pageTitles.count
        pageContentViewController.personalizationTopic = pageTitles[index]
        
        return pageContentViewController
    }
    
}
