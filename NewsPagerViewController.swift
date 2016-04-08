//
//  NewsPagerViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 08/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsPagerViewController: UIViewController {
    
    var newsList: NewsList!
    var viewPager = ViewPagerController()
    var pagerTitle = ""
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge.None
        title = pagerTitle
        
        let options = ViewPagerOptions()
        options.isTabViewHighlightAvailable = false
        options.tabViewHeight = 0
        options.fitAllTabsInView = true
        options.isTabViewHighlightAvailable = true
        
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.view.frame =  view.frame
        addViewControllerAsChild(viewPager)
    }
    
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}



extension NewsPagerViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int
    {
        return newsList.list.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController
    {
        if let newsDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("newsDetailsViewController") as? NewsDetailsViewController {
            newsDetailsViewController.slug = newsList.list[position].slug ?? ""
            return newsDetailsViewController
        }
        return UIViewController()
    }
    
    func pageTitles() -> [String]
    {
        return Array(count: newsList.list.count, repeatedValue: "")
    }
    
    func startViewPagerAtIndex() -> Int {
        return selectedIndex
    }
    
}

