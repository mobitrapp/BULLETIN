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
        NewsDetail.newsDetailWithSlug(slug) { [weak self](newsDetail) -> () in
            self?.newsDetails = newsDetail
            if let activityIndicator = self?.activityIndicator {
                self?.newsDetailTableView.hideActivityIndicator(activityIndicator)
            }
            self?.newsDetailTableView.reloadData()
        }
    }
    
}



extension NewsDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return newsDetails == nil ? 0 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseIndetifier = indexPath.row == 0 ? "newsHeadingCell" : "newsDetailTableviewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIndetifier, forIndexPath: indexPath)
        if let newsDetails = newsDetails {
            (cell as? NewsDetailTableViewCell)?.configureWithNewsDetail(newsDetails)
            (cell as? NewsTitleTableViewCell)?.configureWithNewsDetail(newsDetails)
        }
        
        return cell
    }
    
}


extension NewsDetailsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}