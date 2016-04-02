//
//  UIViewController+Bulletin.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 20/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

extension UIViewController {
    
    
    func childTableViewContentInset(toppadding: CGFloat = 0.0) -> UIEdgeInsets {
        var bottomInset = navigationController?.navigationBar.frame.height ?? 0.0
        bottomInset += UIApplication.sharedApplication().statusBarFrame.size.height ?? 0.0
        
        return UIEdgeInsets(top: toppadding, left: 0.0, bottom: bottomInset, right: 0.0)
    }
    
    func interNetIsAvailable() -> Bool {
        let newtworkReachability = Reach()
        var status = false
        switch newtworkReachability.connectionStatus() {
        case .Online:
            status = true
        default:
            status = false
        }
        return status
    }
    
    func showNoNewscreen() {
        if let noNetworkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NoNetworkViewCOntroller") as? NoNetworkViewController {
            noNetworkViewController.delegate = self
            addViewControllerAsChild(noNetworkViewController)
        }
    }
    
    func removeNoNewsScreen() {
        childViewControllers.forEach {
            if let childViewController = $0 as? NoNetworkViewController {
                removeViewControllerFromParent(childViewController)
            }
        }
    }
    
    func addViewControllerAsChild(childViewController: UIViewController) {
        
        addChildViewController(childViewController)
        childViewController.didMoveToParentViewController(self)
        view.addSubview(childViewController.view)
        
    }
    
    func removeViewControllerFromParent(childViewController: UIViewController) {
        childViewController.willMoveToParentViewController(nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
    
}

extension UIViewController: NoNewsDelegate {
    func retryButtonTapped() {
        
    }
}
