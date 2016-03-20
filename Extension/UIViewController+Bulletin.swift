//
//  UIViewController+Bulletin.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 20/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

extension UIViewController {

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
            
            addChildViewController(noNetworkViewController)
            noNetworkViewController.didMoveToParentViewController(self)
            noNetworkViewController.delegate = self
            view.addSubview(noNetworkViewController.view)
        }
    }
    
    func removeNoNewsScreen() {
        childViewControllers.forEach {
            if let childViewController = $0 as? NoNetworkViewController {
                childViewController.willMoveToParentViewController(nil)
                childViewController.view.removeFromSuperview()
                childViewController.removeFromParentViewController()
            }
        }
    }

}

extension UIViewController: NoNewsDelegate {
    func retryButtonTapped() {
        
    }
}
