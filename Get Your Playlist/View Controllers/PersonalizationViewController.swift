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
    //let currentUser: PFUser = PFUser.current()!

    var moods: [PFObject] = []
    var activities: [PFObject] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PersonaliaztionManager.personalizationManager.getPersonalizationPageTitles(completion: {(titles) in
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
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController

        pageContentViewController.strTitle = "When I'm \(pageTitles[index])..."
        pageContentViewController.pageIndex = index
        pageContentViewController.totalPages = pageTitles.count
        
        return pageContentViewController
    }
    
}
