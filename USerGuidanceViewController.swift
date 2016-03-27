//
//  USerGuidanceViewController.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 24/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class USerGuidanceViewController: UIViewController {
    @IBOutlet weak var userGuidanceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContentInTextView()
        
    }
    
    func loadContentInTextView() {
        let path = NSBundle.mainBundle().pathForResource("About us", ofType: "txt")
        var guidanceString = ""
        if let path = path {
            
            do {
                guidanceString = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
                
            } catch  {
                
            }
            
            
            do {
                let guidanceContentString = try NSAttributedString(data: guidanceString.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                
                let mutableAttributedString = NSMutableAttributedString(attributedString: guidanceContentString)
                mutableAttributedString.setAttributes([ NSFontAttributeName: UIFont.systemFontOfSize(30)], range: NSRangeFromString(guidanceContentString.string))
                userGuidanceTextView.attributedText = mutableAttributedString
            } catch {
                print(error)
            }
            
        }
    }
}
