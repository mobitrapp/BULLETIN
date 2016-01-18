//
//  MenuLIstViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 16/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class MenuListViewController: UIViewController {
    
    @IBOutlet weak var menuListTableViewController: UITableView!
    
    var menuDetail: NewsMenu?
    var categoryIsOpen: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuListTableViewController.estimatedRowHeight = 22
        menuListTableViewController.estimatedSectionFooterHeight = 22
        if let newsMenu = menuDetail?.newsMenu {
            categoryIsOpen = [Bool](count: newsMenu.count, repeatedValue: false)
        }
        menuListTableViewController.tableFooterView = UIView(frame: CGRectZero)
    }
    
}


extension MenuListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let menuDetail = menuDetail?.newsMenu {
            return menuDetail.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let menuDetail = menuDetail?.newsMenu {
            let category = menuDetail[section]
            if let subCategories =  category.subCategories {
                var subCategoryCount = 0
                if categoryIsOpen[section] {
                    subCategoryCount = subCategories.count
                }
                return  subCategoryCount + 1
            } else {
                return 1
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("categoryCell") as! MenuCategoryTableViewCell
            let category = menuDetail!.newsMenu![indexPath.section]
            cell.configureWithCategoryDetail(category, cellIsOpen: categoryIsOpen[indexPath.section])
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("subCategoryCell", forIndexPath: indexPath) as! MenuSubCategoryTableViewCell
            let subCategories = menuDetail!.newsMenu![indexPath.section].subCategories!
            let subCategory = subCategories[indexPath.row - 1]
            cell.configureWithSubCategoryDetail(subCategory)
            return cell
        }
    }
    
}

extension MenuListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            categoryIsOpen[indexPath.section] = !categoryIsOpen[indexPath.section]
            let  indexRange = NSMakeRange(indexPath.section, 1)
            let sectionsToReload = NSIndexSet(indexesInRange: indexRange)
            tableView.reloadSections(sectionsToReload, withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
}
