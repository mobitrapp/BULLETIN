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
    var topNewsList: TopNewsList!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        slideMenuController()?.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureHomeScreen()
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
    
    func configureHomeScreen() {
        if let homeSCreeViewController = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController {
            homeSCreeViewController.topNewsList = topNewsList
            addChildViewController(homeSCreeViewController)
            view.addSubview(homeSCreeViewController.view)
            homeSCreeViewController.didMoveToParentViewController(self)
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
