//
//  HomeViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    var homeScreenViewModel: HomeScreenViewModel!
    let topNewsCount = 4
    let karntakaNewsCount = 8
    let specialCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.addSubview(refreshControl)
        refreshControl.tintColor = UIColor.bulletinRed()
        if !homeScreenViewModel.newsIsAvailable() {
            showNoNewscreen()
        }
        
        refreshControl.addTarget(self, action: "refreshFeed", forControlEvents: UIControlEvents.ValueChanged)
        
        var bottomInset = navigationController?.navigationBar.frame.height ?? 0.0
        
        bottomInset += UIApplication.sharedApplication().statusBarFrame.size.height ?? 0.0
        
        homeTableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: bottomInset, right: 0)
        homeTableView.estimatedRowHeight = 50
    }
    
}


extension HomeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func titleForNewsAtIndexPath(indexPath: NSIndexPath) -> String {
        
        var title = ""
        switch indexPath.section {
        case 0:
            title = "News"
            
        case 1:
            title = "Karnataka"
            
        default:
            title = "Special"
        }
        return title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return numberOfRowsInNewsList(homeScreenViewModel.topNewsList, estimatedNumberOfSections: topNewsCount)
        case 1:
            return numberOfRowsInNewsList(homeScreenViewModel.karnatakaNewsList,estimatedNumberOfSections: karntakaNewsCount)
        case 2:
            return numberOfRowsInNewsList(homeScreenViewModel.specialNewsList,estimatedNumberOfSections: specialCount)
        default:
            return 0
        }
    }
    
    func numberOfRowsInNewsList(newsList: NewsList?, estimatedNumberOfSections: Int) -> Int {
        if let newsList = newsList {
            if newsList.list.isEmpty {
                return 0
            } else if newsList.list.count > estimatedNumberOfSections {
                return estimatedNumberOfSections + 1
            } else {
                return newsList.list.count + 1
            }
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("SectionTitleTableViewCell", forIndexPath: indexPath)
            (cell as? SectionTitleTableViewCell)?.configureWithTitle(titleForNewsAtIndexPath(indexPath))
        } else {
            
            var news: News?
            if indexPath.section == 0 {
                news = homeScreenViewModel.topNewsList!.list[indexPath.row - 1]
            } else if indexPath.section == 1{
                news = homeScreenViewModel.karnatakaNewsList!.list[indexPath.row - 1]
            } else if indexPath.section == 2 {
                news = homeScreenViewModel.specialNewsList!.list[indexPath.row - 1]
            }
            
            cell = tableView.dequeueReusableCellWithIdentifier("NewsListTableViewCell", forIndexPath: indexPath)
            if let news = news {
                ( cell as? NewsListTableViewCell)?.configureWithNews(news)
            }
        }
        return cell
        
    }
    
    func refreshFeed() {
        
        HomeScreenViewModel.loadHomeScreenViewModelWithCompletionHandler { [weak self](homeScreenViewModel) -> () in
            if homeScreenViewModel.newsIsAvailable() {
                self?.homeScreenViewModel = homeScreenViewModel
                self?.removeNoNewsScreen()
                self?.refreshControl.endRefreshing()
                self?.homeTableView.reloadData()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    override func retryButtonTapped() {
        refreshFeed()
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}