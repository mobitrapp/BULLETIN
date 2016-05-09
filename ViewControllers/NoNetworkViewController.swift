//
//  NoNetworkViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 21/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

enum ScreenMode {
    case NoInternet
    case NoNews
}

protocol NoNewsDelegate {
    func retryButtonTapped()
}

class NoNetworkViewController: UIViewController {
    var delegate: NoNewsDelegate?
    var screenMode = ScreenMode.NoInternet
    
    
    @IBOutlet weak var problemDescriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if screenMode == .NoInternet {
            problemDescriptionLabel.text = "No Internet connection, Please try again Later"
            if let  newsImage = UIImage(named: "NoInternet") {
                newsImageView.image = newsImage
            }
        }
    }
    
    
    @IBAction func retryButtonTapped(sender: AnyObject) {
        delegate?.retryButtonTapped()
    }
    
}
