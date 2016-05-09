//
//  HomeViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate {
    func moreButtonTappedWithSectionType(sectionType: HomeScreenNewsSectionType)
    func viewModelDidUpdate(viewModel: HomeScreenViewModel)
}


class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    lazy var refreshControl = UIRefreshControl()
    var homeScreenViewModel: HomeScreenViewModel!
    var delegate: HomeViewControllerDelegate?
    let topNewsCount = 4
    let karntakaNewsCount = 8
    let specialCount = 3
    var snackBar: TTGSnackbar?
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.color = UIColor.bulletinRed()
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.addSubview(refreshControl)
        refreshControl.tintColor = UIColor.bulletinRed()
        if !homeScreenViewModel.newsIsAvailable() {
            showNoNewscreen()
        }
        refreshControl.addTarget(self, action: "refreshFeed", forControlEvents: UIControlEvents.ValueChanged)
        homeTableView.estimatedRowHeight = 50
        homeTableView.contentInset = childTableViewContentInset(2)
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
            title = "Top news"
            
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
            (cell as? SectionTitleTableViewCell)?.configureWithTitle(titleForNewsAtIndexPath(indexPath), sectionType: HomeScreenNewsSectionType(rawValue: indexPath.section)!)
            (cell as? SectionTitleTableViewCell)?.delegate = self
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
        
        if interNetIsAvailable() {
            HomeScreenViewModel.loadHomeScreenViewModelWithCompletionHandler { [weak self](homeScreenViewModel) -> () in
                if let activityIndicator = self?.activityIndicator {
                    self?.homeTableView?.hideActivityIndicator(activityIndicator)
                }
                if homeScreenViewModel.newsIsAvailable() {
                    self?.homeScreenViewModel = homeScreenViewModel
                    self?.delegate?.viewModelDidUpdate(homeScreenViewModel)
                    self?.removeNoNewsScreen()
                    self?.refreshControl.endRefreshing()
                    self?.homeTableView.reloadData()
                } else {
                    self?.refreshControl.endRefreshing()
                    if let homeScreenViewModel = self?.homeScreenViewModel {
                        if !homeScreenViewModel.newsIsAvailable() {
                            self?.showNoNewscreen()
                        }
                    }
                }
            }
        } else {
            snackBar?.dismiss()
            snackBar = nil
            refreshControl.endRefreshing()
            snackBar = TTGSnackbar.init(message: " No Internet Connection", duration: TTGSnackbarDuration.Long)
            snackBar?.actionText = "Retry!"
            snackBar?.actionTextColor = UIColor.bulletinRed()!
            snackBar?.actionBlock  = {[weak self] (snackBar) in
              self?.refreshFeed()
            }
            snackBar?.show()
        }
    }
    
    override func retryButtonTapped() {
        refreshFeed()
        if let homeScreenViewModel = self.homeScreenViewModel {
            if !homeScreenViewModel.newsIsAvailable() {
                homeTableView?.showActivityIndicator(activityIndicator)
                removeNoNewsScreen()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        snackBar?.dismiss()
        snackBar = nil
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row != 0 {
            if let newsPagerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("newsPagerViewController") as? NewsPagerViewController  {
                
                
                var newsList: NewsList!
                if indexPath.section == 0 {
                    newsList = homeScreenViewModel.topNewsList
                } else if indexPath.section == 1{
                    newsList = homeScreenViewModel.karnatakaNewsList
                } else if indexPath.section == 2 {
                    newsList = homeScreenViewModel.specialNewsList
                }
                
                if let newsList = newsList {
                    newsPagerViewController.newsList = newsList
                    newsPagerViewController.pagerTitle = titleForNewsAtIndexPath(indexPath)
                    newsPagerViewController.selectedIndex = indexPath.row - 1
                }
                
                let newsDetailNavigationController = UINavigationController(rootViewController: newsPagerViewController)
                
                presentViewController(newsDetailNavigationController, animated: true, completion: nil)
            }
            
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension HomeViewController: SectionTitleTableViewCellDelegate {
    
    func moreButtonTappedForSectionType(sectionType: HomeScreenNewsSectionType) {
        delegate?.moreButtonTappedWithSectionType(sectionType)
    }
}