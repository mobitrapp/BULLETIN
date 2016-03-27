//
//  NewsListViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 21/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit



class NewsListViewController: UIViewController {
    
    var newsList: NewsList?
    var pageIndicator: PaginationTracker!
    var requestType: BulletinRequest?
    var newsIsFetching = false
    @IBOutlet weak var newsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageIndicator = requestType?.pageIndicator
        fetchFeed()
        newsListTableView.estimatedRowHeight = 50
        newsListTableView.estimatedSectionHeaderHeight = 35
        newsListTableView.contentInset = childTableViewContentInset()
    }
    
    func fetchFeed() {
        if let requestType = requestType {
            
            HomeScreenViewModel.getNewsWithRequest(requestType, completionHandler: { [weak self](newsList) -> () in
                
                if self?.newsList == nil {
                    self?.newsList = newsList
                } else {
                    self?.newsList?.list += newsList.list
                }
                
                self?.newsIsFetching = false
                if newsList.list.count <= 0 {
                    self?.showNoNewscreen()
                } else {
                    self?.removeNoNewsScreen()
                    self?.newsListTableView.reloadData()
                }
                
                })
        }
        
    }
    
    override func retryButtonTapped() {
        fetchFeed()
    }
    
    func newsTitleForCurrentScreen() -> String {
        var newsTitle = ""
        
        if let  requestType = requestType {
            switch requestType {
                
            case .TopNews :
                newsTitle = "Top news"
            case .KarnatakaNews :
                newsTitle = "Karnataka"
                
            case .SpecialNews :
                newsTitle = "Special"
                
            default:
                newsTitle = ""
            }
            
        }
        return newsTitle
    }
    
}

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let newsCount = newsList?.list.count {
            return pageIndicator.page < 5 ? newsCount + 1 : newsCount
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell: UITableViewCell
        
        if indexPath.row ==  newsList!.list.count {
            cell = tableView.dequeueReusableCellWithIdentifier("ActivityIndicatorTableViewCell", forIndexPath: indexPath)
            (cell as? ActivityIndicatorTableViewCell)?.startAnimating()
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("NewsListTableViewCell", forIndexPath: indexPath)
            if let news = newsList?.list[indexPath.row ] {
                (cell as? NewsListTableViewCell)?.configureWithNews(news)
                
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            if !newsIsFetching && interNetIsAvailable() {
                newsIsFetching = true
                pageIndicator.incrementToNextSetOfNews()
                if pageIndicator.page <= 5 {
                   fetchFeed()
                }
            }
        }
        
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("SectionTitleTableViewCell")
        (cell as? SectionTitleTableViewCell)?.configureWithTitle(newsTitleForCurrentScreen(), sectionType: nil)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
