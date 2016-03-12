//
//  SettingsTableViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 18/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonTapped")
        navigationItem.leftBarButtonItem = backButton
        
        tableView.separatorStyle = .None
        navigationController?.navigationBar.barTintColor = UIColor.bulletinLightRed()
        navigationController?.navigationBar.topItem?.title = "Settings"
    }

    func backButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
