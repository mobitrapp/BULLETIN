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
    var topNewsList: TopNewsList!
    let headerHeight: CGFloat = 35.0
    let cellHeight: CGFloat = 90
    let topNewsCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        homeTableView.estimatedRowHeight = 50
    }

}


extension HomeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if topNewsList.list.isEmpty {
                return 0
            } else if topNewsList.list.count > topNewsCount {
                return topNewsCount + 1
            } else {
                return topNewsList.list.count + 1
            }
            
        default:
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("SectionTitleTableViewCell", forIndexPath: indexPath)
        } else {
             cell = tableView.dequeueReusableCellWithIdentifier("NewsListTableViewCell", forIndexPath: indexPath)
           ( cell as? NewsListTableViewCell)?.configureWithTopNews(topNewsList.list[indexPath.row - 1])
        }
        return cell
        
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.row == 0) ? headerHeight : cellHeight
    }
}