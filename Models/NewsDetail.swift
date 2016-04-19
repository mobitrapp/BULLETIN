//
//  NewsDetail.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 03/04/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit
typealias newsDetailResponseHandler = (NewsDetail?) -> ()

class NewsDetail {
    var title = ""
    var updatedDate = ""
    var publishedDate = ""
    var imageURLs = [String]()
    var publishedBy = ""
    var displayPostedBy = ""
    var news = ""
    var shareLink = ""
    
    init () {
        
    }
    
    init(detailDictionary: NSDictionary){
        
        title = detailDictionary["title"] as? String ?? ""
        updatedDate = detailDictionary["updated_at"] as? String ?? ""
        publishedBy = detailDictionary["posted_by"] as? String ?? ""
        displayPostedBy = detailDictionary["display_posted_by"] as? String ?? ""
        news = detailDictionary["content"] as? String ?? ""
        publishedDate = detailDictionary["published_at"] as? String ?? ""
        shareLink = detailDictionary["share_link"] as? String ?? ""
        imageURLs = detailDictionary["uploaded_more_image"] as? [String] ?? [String]()
    }
    
    class func newsDetailWithSlug(slug: String, completionHandler: newsDetailResponseHandler)  {
        APIServiceManager.sharedInstance.getNewsDetailWIihSlug(slug) { (result) -> Void in
            
            switch result {
            case .Success(let result):
                if let detailDictionary = result as? NSDictionary {
                    completionHandler(NewsDetail(detailDictionary: detailDictionary))
                }
            case .Failure:
                
                completionHandler(nil)
            }
            
        }
    }
    
}
