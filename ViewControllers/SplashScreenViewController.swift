//
//  SplashScreenViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 13/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var retryTokenGenerationButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        retryTokenGenerationButton.hidden = true
        navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initiateApp()
    }
    
    func initiateApp() {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        APIServiceManager.sharedInstance.appShouldProceed { [weak self] (result) -> Void in
            
            switch result {
            case .Success(let appShouldProceed):
                if let appShouldProceed = appShouldProceed as? Bool {
                    if !appShouldProceed {
                        self?.showInitialisationFailedAlert()
                        return
                    }
                }
                self?.generateToken()
            case .Failure:
                self?.generateToken()
            }
            
        }
    }
    
    func generateToken() {
        
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        if NSUserDefaults.standardUserDefaults().objectForKey (GlobalStrings.APIToken.rawValue) == nil {
            APIServiceManager.sharedInstance.generateTokenWithDeviceID(UIDevice.currentDevice().identifierForVendor?.UUIDString) { [weak self](result) -> Void in
                
                switch result {
                    
                case .Success(let token):
                    print(token)
                    NSUserDefaults.standardUserDefaults().setObject(token, forKey: GlobalStrings.APIToken.rawValue)
                    self?.configureAndPushLandingScreen()
                    self?.retryTokenGenerationButton.hidden = true
                    
                case .Failure:
                    self?.showInitialisationFailedAlert()
                }
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.hidden = true
                
            }
        } else {
            configureAndPushLandingScreen()
        }
        
    }
    
    func configureAndPushLandingScreen() {
        
        let menuListWidth = UIScreen.mainScreen().bounds.width * 0.8
        SlideMenuOptions.leftViewWidth = menuListWidth
        SlideMenuOptions.simultaneousGestureRecognizers = false
        SlideMenuOptions.hideStatusBar = false
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewControllerWithIdentifier("landingViewController")
        
        let leftMenuViewController = mainStoryboard.instantiateViewControllerWithIdentifier("menuListViewController")
        
        if let menuListController = leftMenuViewController as? MenuListViewController {
            let menuDetail = NewsMenu.loadMenuFromJsonFile()
            menuListController.menuDetail = menuDetail
        }
        
        let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftMenuViewController)
        
        if let mainViewController = mainViewController as? LandingViewController {
            slideMenuController.delegate = mainViewController
        }
        
        if let menuButtonImage = UIImage(named: "MenuButton") {
            slideMenuController.addLeftBarButtonWithImage(menuButtonImage)
            
        }
        
        if let menuButtonImage = UIImage(named: "Settings") {
            slideMenuController.addRightBarButtonWithImage(menuButtonImage)
        }
        
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
        HomeScreenViewModel.loadHomeScreenViewModelWithCompletionHandler { [weak self](homeScreenViewModel) -> () in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.hidden = true
            if let landingViewController = slideMenuController.mainViewController as? LandingViewController {
                landingViewController.homeScreenViewModel = homeScreenViewModel
                self?.navigationController?.pushViewController(slideMenuController, animated: false)
                
            }
        }
    }
    
        
        func showInitialisationFailedAlert() {
            let alertController = UIAlertController(title: "oops! App initialisation Failed", message: "Something went wrong while initialising the app. Would you like to try again?  ", preferredStyle: .Alert)
            let notNowAction = UIAlertAction(title: "Not Now", style: UIAlertActionStyle.Cancel) { [weak self](action) -> Void in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.hidden = true
                self?.retryTokenGenerationButton.hidden = false
            }
            alertController.addAction(notNowAction)
            
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .Default) { [weak self](action) -> Void in
                self?.initiateApp()
                
            }
            alertController.addAction(tryAgainAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        
        @IBAction func retryTokenGenerationButtonTapped(sender: AnyObject) {
            retryTokenGenerationButton.hidden = true
            initiateApp()
        }
        
}
