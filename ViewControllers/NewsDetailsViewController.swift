//
//  NewsDetailsTableViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 07/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    
    var newsDetails: NewsDetail?
    var slug = ""
    
    let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.color = UIColor.bulletinRed()
        return activityIndicator
    }()
    
    @IBOutlet weak var newsDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsDetailTableView.showActivityIndicator(activityIndicator)
        newsDetailTableView.estimatedRowHeight = 103
        loadNewsDetails()
    }
    
    func loadNewsDetails() {
        dispatch_async(backgroundQueue) {[weak self] () -> Void in
            
            NewsDetail.newsDetailWithSlug(self?.slug ?? "") { [weak self](newsDetail) -> () in
                self?.newsDetails = newsDetail
                if let activityIndicator = self?.activityIndicator {
                    self?.newsDetailTableView.hideActivityIndicator(activityIndicator)
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self?.newsDetailTableView.reloadData()
                }
            }
            
            
        }
    }
    
}



extension NewsDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return newsDetails == nil ? 0 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if newsDetails?.imageURLs.count > 0 {
            return 3
        }
        
        return 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var reuseIndetifier = ""
        
        if indexPath.row == 0 {
            reuseIndetifier = "newsHeadingCell"
        } else {
            if tableView.numberOfRowsInSection(indexPath.section) == 3 && indexPath.row == 1 {
                reuseIndetifier = "newsImagesTableViewCell"
            } else {
                reuseIndetifier = "newsDetailTableviewCell"
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIndetifier, forIndexPath: indexPath)
        if let newsDetails = newsDetails {
            (cell as? NewsDetailTableViewCell)?.configureWithNewsDetail(newsDetails)
            (cell as? NewsTitleTableViewCell)?.configureWithNewsDetail(newsDetails)
            (cell as? NewsImagesTableViewCell)?.imagesURL = newsDetails.imageURLs
        }
        
        return cell
    }
    
}


extension NewsDetailsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension NewsDetailsViewController: NewsPagerViewControllerDelegate {
    func URLToShareNews() -> String? {
        if let shareLink = newsDetails?.shareLink {
            if !shareLink.isEmpty {
                return shareLink
            }
        }
        return nil
        
    }
}