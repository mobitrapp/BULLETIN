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
    var subCategory = ""
    var newsIsFetching = false
    var shouldShowIndicator = true
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.color = UIColor.bulletinRed()
        return activityIndicator
    }()
    
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
        newsIsFetching = true
        if let requestType = requestType {
            
            if newsList == nil {
                newsListTableView.showActivityIndicator(activityIndicator)
            }
            
            HomeScreenViewModel.getNewsWithRequest(requestType, completionHandler: { [weak self](newsList) -> () in
                
                if let activityIndicator = self?.activityIndicator {
                    self?.newsListTableView.hideActivityIndicator(activityIndicator)
                }
                
                
                if self?.newsList == nil {
                    self?.newsList = newsList
                } else {
                    self?.newsList?.list += newsList.list
                }
                
                self?.newsIsFetching = false
                if self?.newsList?.list.count <= 0 {
                    if let weakSelf = self where !weakSelf.interNetIsAvailable() {
                       self?.showNoNewscreen(.NoInternet)
                    } else {
                        self?.showNoNewscreen()
                    }
                } else {
                    if let pageIndicator = self?.pageIndicator {
                        if  self?.newsList?.list.count < (pageIndicator.limit * pageIndicator.page) {
                            if let interNetisAvailable = self?.interNetIsAvailable() {
                                if interNetisAvailable {
                                    self?.shouldShowIndicator = false
                                }
                            }
                        } else {
                            self?.shouldShowIndicator = true
                        }
                        
                    }
                    
                    self?.removeNoNewsScreen()
                    self?.newsListTableView.reloadData()
                }
                
                })
        }
        
    }
    
    override func retryButtonTapped() {
        if interNetIsAvailable() {
            fetchFeed()
            if newsList?.list.count <= 0 {
                removeNoNewsScreen()
                newsListTableView.showActivityIndicator(activityIndicator)
            }
        }
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
                newsTitle = subCategory
            }
            
        }
        return newsTitle
    }
    
}

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let newsCount = newsList?.list.count {
            if !shouldShowIndicator {
                return newsCount
            }
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
            if !newsIsFetching && interNetIsAvailable() &&  pageIndicator.page <= 4 && shouldShowIndicator {
                
                pageIndicator.incrementToNextSetOfNews()
                fetchFeed()
                
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if let newsPagerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("newsPagerViewController") as? NewsPagerViewController {
            if let newsList = newsList {
                newsPagerViewController.newsList = newsList
                newsPagerViewController.pagerTitle = newsTitleForCurrentScreen()
                newsPagerViewController.selectedIndex = indexPath.row
            }
            let newsDetailNavigationController = UINavigationController(rootViewController: newsPagerViewController)
            
            presentViewController(newsDetailNavigationController, animated: true, completion: nil)
        }
        
    }
    
}

