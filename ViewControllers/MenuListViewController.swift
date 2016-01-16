//
//  MenuLIstViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 16/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class MenuListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension MenuListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 13
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
        return cell
    }
}

extension MenuListViewController: UITableViewDelegate {
    
}
