//
//  USerGuidanceViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 24/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

enum GuidanceMode: String {
    case AboutUs = "About us"
    case ServiceTerms = "Service terms" 
    case PrivacyPolicy = "Privacy policy"
}

class USerGuidanceViewController: UIViewController {
    @IBOutlet weak var userGuidanceTextView: UITextView!
    var guidanceMode = GuidanceMode.PrivacyPolicy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContentInTextView()
        title = guidanceMode.rawValue
    }
    
    func loadContentInTextView() {
        let path = NSBundle.mainBundle().pathForResource(guidanceMode.rawValue, ofType: "txt")
        var guidanceString = ""
        if let path = path {
            
            do {
                guidanceString = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                userGuidanceTextView.text = guidanceString
            } catch  {
                
            }
            
        }
    }
}
