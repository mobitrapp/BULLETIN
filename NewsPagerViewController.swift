//
//  NewsPagerViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 08/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

protocol NewsPagerViewControllerDelegate {
    func URLToShareNews() -> String?
}

class NewsPagerViewController: UIViewController {
    
    var newsList: NewsList!
    var viewPager = ViewPagerController()
    var pagerTitle = ""
    var selectedIndex = 0
    var delegate: NewsPagerViewControllerDelegate?
    
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
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        if let newsURL = delegate?.URLToShareNews() {
            presentActivityControllerWithURL(newsURL)
        }
        
    }
}



extension NewsPagerViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int
    {
        return interNetIsAvailable() ? newsList.list.count : 1
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController
    {
        if interNetIsAvailable() {
            if let newsDetailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("newsDetailsViewController") as? NewsDetailsViewController {
                newsDetailsViewController.slug = newsList.list[position].slug ?? ""
                delegate = newsDetailsViewController
                return newsDetailsViewController
            }
        } else {
            if let noNetworkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NoNetworkViewCOntroller") as? NoNetworkViewController {
                noNetworkViewController.delegate = self
                noNetworkViewController.screenMode = .NoInternet
                return noNetworkViewController
            }
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
    
    override func retryButtonTapped() {
        if interNetIsAvailable() {
            viewPager.view.userInteractionEnabled = false
            viewPager.displayChoosenViewController(selectedIndex)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] _ in
                self?.viewPager.view.userInteractionEnabled = true
            }
            
        }
    }
}


