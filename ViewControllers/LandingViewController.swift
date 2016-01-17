//
//  ViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit


class LandingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        if let navigationBar = slideMenuController()?.navigationController?.navigationBar {
            if let newsIcon = UIImage(named: "NavigationIcon") {
                let newsIconImageView = UIImageView(image:newsIcon)
                
                let iconCenter = CGPoint(x: navigationBar.bounds.size.width / 2, y: navigationBar.bounds.size.height / 2 )
                newsIconImageView.center = iconCenter
                navigationBar.addSubview(newsIconImageView)
            }
        }
        
    }
    
}

