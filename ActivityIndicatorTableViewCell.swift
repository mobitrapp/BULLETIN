//
//  ActivityIndicatorTableViewCell.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 23/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class ActivityIndicatorTableViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
}
