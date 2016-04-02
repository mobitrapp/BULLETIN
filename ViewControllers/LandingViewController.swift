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
    var homeScreenViewModel: HomeScreenViewModel!
    var childViewController: UIViewController?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureHomeScreen()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        slideMenuController()?.navigationController?.setNavigationBarHidden(false, animated: false)
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
            childViewController = homeSCreeViewController
            homeSCreeViewController.homeScreenViewModel = homeScreenViewModel
            
            homeSCreeViewController.delegate = self
            addViewControllerAsChild(homeSCreeViewController)
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


extension LandingViewController: HomeViewControllerDelegate {
    func moreButtonTappedWithSectionType(sectionType: HomeScreenNewsSectionType) {
        var newsRequestType: BulletinRequest!
        switch sectionType {
        case .TopNews :
            newsRequestType = BulletinRequest.TopNews(PaginationTracker())
        case .Karnataka:
            newsRequestType = BulletinRequest.KarnatakaNews(PaginationTracker())
        case .Special:
            newsRequestType = BulletinRequest.SpecialNews(PaginationTracker())
        }
        
        showNewsScreenWithRequest(newsRequestType, subcategory: "")
    }
    
    
    func viewModelDidUpdate(viewModel: HomeScreenViewModel) {
        homeScreenViewModel = viewModel
    }
    
    func showNewsScreenWithRequest(request: BulletinRequest, subcategory: String) {
        
        if let childViewController = childViewController {
            removeViewControllerFromParent(childViewController)
        }
        
        if let newsListViewController = storyboard?.instantiateViewControllerWithIdentifier("NewsListViewController") as? NewsListViewController {
            newsListViewController.requestType = request
            newsListViewController.subCategory = subcategory
            addViewControllerAsChild(newsListViewController)
            childViewController = newsListViewController
        }
    }
    
    
}

extension LandingViewController: MenuListViewControllerDelegate {
    func menuListDidSelectWithSubCategory(subCategory: SubCategory?) {
        if let childViewController = childViewController {
            removeViewControllerFromParent(childViewController)
        }
        
        if let subCategory = subCategory {
            
            showNewsScreenWithRequest(BulletinRequest.commonNews(PaginationTracker(), subCategory.code),subcategory: subCategory.name)
            
        } else {
            configureHomeScreen()
        }
        
    }
}
