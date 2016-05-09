//
//  String+Bulletin.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 15/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

extension String {
    func plainText() -> String {
        guard let data = dataUsingEncoding(NSUTF8StringEncoding)
            else { return "" }
        do {
            let plainAttributedString: NSAttributedString = try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            return plainAttributedString.string
        } catch  {
            return  ""
        }
    }
}
