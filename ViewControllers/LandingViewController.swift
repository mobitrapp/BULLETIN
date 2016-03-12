//
//  ViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit


class LandingViewController: UIViewController {
    var navigationIconImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }

    private func configureNavigationBar() {
        if let navigationBar = slideMenuController()?.navigationController?.navigationBar {
            if let newsIcon = UIImage(named: "NavigationIcon") {
                let newsIconImageView = UIImageView(image:newsIcon)
                navigationIconImageView = newsIconImageView
                let iconCenter = CGPoint(x: navigationBar.bounds.size.width / 2, y: navigationBar.bounds.size.height / 2 )
                newsIconImageView.center = iconCenter
                navigationBar.addSubview(newsIconImageView)
            }
        }
        
    }
    
}


extension LandingViewController: SlideMenuControllerDelegate {
    
    func settingsButtonDidTap() {
        
        let settingsViewController = storyboard?.instantiateViewControllerWithIdentifier("settingsTableViewController")
        if let settingsViewController = settingsViewController {
            let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
            slideMenuController()?.navigationController?.presentViewController(settingsNavigationController, animated: true, completion: nil)
        }
    }
}
