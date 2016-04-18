//
//  SettingsTableViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 18/01/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit
import MessageUI

enum SettingCellTitle: Int {
    case support
    case ShareThisApp = 1
    case Help
    case Feedback
    case RateUs
    case Information
    case Aboutus
    case ServiceTerms
    case PrivacyPolicy
}

class SettingsTableViewController: UITableViewController {
    var guidanceMode = GuidanceMode.AboutUs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtonTapped")
        navigationItem.leftBarButtonItem = backButton
        
        tableView.separatorStyle = .None
        navigationController?.navigationBar.barTintColor = UIColor.bulletinRed()
        navigationController?.navigationBar.topItem?.title = "Settings"
    }
    
    func backButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case SettingCellTitle.Help.rawValue, SettingCellTitle.Feedback.rawValue:
            showMailComposerViewControllerForCellTitle(SettingCellTitle(rawValue: indexPath.row )!)
            
        case SettingCellTitle.ServiceTerms.rawValue,
        SettingCellTitle.Aboutus.rawValue,
        SettingCellTitle.PrivacyPolicy.rawValue:
            guidanceMode = indexPath.row == SettingCellTitle.ServiceTerms.rawValue ? GuidanceMode.ServiceTerms : indexPath.row ==  SettingCellTitle.Aboutus.rawValue ? GuidanceMode.AboutUs : GuidanceMode.PrivacyPolicy
            pushGuidanceViewController()
            
        default:
            break
        }
    }
    
    func showMailComposerViewControllerForCellTitle(cellTitle: SettingCellTitle) {
        
        if MFMailComposeViewController.canSendMail() {
            let subject = cellTitle == .Help ? "Help" : "Feedback"
            let mailComposerViewController = MFMailComposeViewController()
            mailComposerViewController.mailComposeDelegate = self
            mailComposerViewController.setSubject(subject)
            mailComposerViewController.setToRecipients(["contact@newskarnataka.com"])
            mailComposerViewController.setMessageBody("Description goes here", isHTML: false)
            presentViewController(mailComposerViewController, animated: true, completion: nil)
        } else {
            showUnableToSendEmailAlert()
        }
    }
    
    
    func showUnableToSendEmailAlert() {
        let alertController = UIAlertController(title: "oops! Unable to send email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func pushGuidanceViewController() {
        if let guidanceViewController = storyboard?.instantiateViewControllerWithIdentifier("GuidanceViewController") as? USerGuidanceViewController{
            guidanceViewController.guidanceMode = guidanceMode
            navigationController?.pushViewController(guidanceViewController, animated: true)
        }
    }
}



extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
