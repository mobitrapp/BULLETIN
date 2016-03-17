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
    var homeScreenViewModel: HomeScreenViewModel!
    let headerHeight: CGFloat = 35.0
    let cellHeight: CGFloat = 90
    let topNewsCount = 4
    let karntakaNewsCount = 8
    let specialCount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 70, right: 0)
        homeTableView.estimatedRowHeight = 50
    }
    
}


extension HomeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
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
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.row == 0) ? headerHeight : cellHeight
    }
}