//
//  MenuLIstViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 16/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class MenuListViewController: UIViewController {
    
    @IBOutlet weak var menuListTableView: UITableView!
    
    var menuDetail: NewsMenu?
    var categoryIsOpen: [Bool]!
    var openedSection = Int.min
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuListTableView.estimatedRowHeight = 22
        menuListTableView.estimatedSectionFooterHeight = 22
        if let newsMenu = menuDetail?.newsMenu {
            categoryIsOpen = [Bool](count: newsMenu.count, repeatedValue: false)
        }
        menuListTableView.tableFooterView = UIView(frame: CGRectZero)
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
            if openedSection != indexPath.section && openedSection != Int.min {
                categoryIsOpen[openedSection] = false
                reloadTableViewSection(openedSection)
            }
            categoryIsOpen[indexPath.section] = !categoryIsOpen[indexPath.section]
            reloadTableViewSection(indexPath.section)
            openedSection = indexPath.section
        } else {
            categoryIsOpen[openedSection] = false
            reloadTableViewSection(indexPath.section)
            
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.30 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
              self.closeLeft()
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func reloadTableViewSection(section: Int) {
        let  indexRange = NSMakeRange(section, 1)
        let sectionsToReload = NSIndexSet(indexesInRange: indexRange)
        menuListTableView.reloadSections(sectionsToReload, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
}
