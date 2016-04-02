//
//  UITableView+Bulletin.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 02/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

extension UITableView {
    
    func showActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        self.layoutIfNeeded()
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
}
