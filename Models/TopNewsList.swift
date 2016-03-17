//
//  TopNewsList.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 14/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class News {
    
    var id = ""
    var title = ""
    var slug = ""
    var publishedAt = ""
    var shortDescription = ""
    var imageURL = ""
    var postedBy = ""
    var categoryID = 0
    var displayPostedBy = ""
    var updatedAt = ""
    
    init(topNewsDictionary: NSDictionary) {
        id = topNewsDictionary["news_id"] as? String ?? ""
        title = topNewsDictionary["news_title"] as? String ?? ""
        slug = topNewsDictionary["news_slug"] as? String ?? ""
        publishedAt = topNewsDictionary["published_at"] as? String ?? ""
        shortDescription = topNewsDictionary["short_description"] as? String ?? ""
        imageURL = topNewsDictionary["image_preview"] as? String ?? ""
        categoryID = topNewsDictionary["posted_by"] as? Int ?? Int.min
        displayPostedBy = topNewsDictionary["display_posted_by"] as? String ?? ""
        updatedAt = topNewsDictionary["updated_at"] as? String ?? ""
        
    }
    
}



class NewsList {
    var list: [News]
    
    init() {
        list = []
    }
    
    init(newsArray: NSArray) {
        list = [News]()
        for news in newsArray {
            if let newsDictionary = news as? NSDictionary {
                list.append(News(topNewsDictionary: newsDictionary))
            }
            
        }
    }
    
}
