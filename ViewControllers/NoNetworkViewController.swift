//
//  NoNetworkViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 21/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

protocol NoNewsDelegate {
    func retryButtonTapped()
}

class NoNetworkViewController: UIViewController {
    var delegate: NoNewsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func retryButtonTapped(sender: AnyObject) {
        delegate?.retryButtonTapped()
    }

}
