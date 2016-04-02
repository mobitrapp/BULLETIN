//
//  TopNewsList.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 14/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class News: NSObject, NSCoding {
    
    var id = ""
    var title = ""
    var slug = ""
    var publishedAt = ""
    var shortDescription = ""
    var imageURL = ""
    var postedBy = ""
    var categoryID = 0
    var displayPostedBy = ""
    var updatedAt = 0
    
    init(topNewsDictionary: NSDictionary) {
        id = topNewsDictionary["news_id"] as? String ?? ""
        title = topNewsDictionary["news_title"] as? String ?? ""
        slug = topNewsDictionary["news_slug"] as? String ?? ""
        publishedAt = topNewsDictionary["published_at"] as? String ?? ""
        shortDescription = topNewsDictionary["short_description"] as? String ?? ""
        imageURL = topNewsDictionary["image_preview"] as? String ?? ""
        postedBy = topNewsDictionary["posted_by"] as? String ?? ""
        displayPostedBy = topNewsDictionary["display_posted_by"] as? String ?? ""
        updatedAt = topNewsDictionary["updated_at"] as? Int ?? 0
        
    }
    
    
    required convenience init?(coder decoder: NSCoder) {
        guard let ID = decoder.decodeObjectForKey("news_id") as? String,
            let title = decoder.decodeObjectForKey("news_title") as? String,
            let slug = decoder.decodeObjectForKey("news_slug") as? String,
            let publishedAt = decoder.decodeObjectForKey("published_at") as? String,
            let shortDescription = decoder.decodeObjectForKey("short_description") as? String,
            let imageURL = decoder.decodeObjectForKey("image_preview") as? String,
            let _ = decoder.decodeObjectForKey("posted_by") as? String,
            let displayPostedBy = decoder.decodeObjectForKey("display_posted_by") as? String,
            let updatedAt = decoder.decodeObjectForKey("updated_at") as? Int
            else {
                
                return nil }
        
        self.init(id: ID, title: title, slug: slug, publishedAt: publishedAt, description: shortDescription, url: imageURL,categoryID: 0, displayPostedBy: displayPostedBy,updatedAt: updatedAt)
    }
    
    init(id: String, title: String, slug: String, publishedAt: String, description: String, url: String, categoryID: Int, displayPostedBy: String,updatedAt: Int) {
        self.id = id
        self.title = title
        self.slug = slug
        self.publishedAt = publishedAt
        self.shortDescription = description
        self.imageURL = url
        self.categoryID = categoryID
        self.displayPostedBy = displayPostedBy
        self.updatedAt = updatedAt
    }
    
    
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.id, forKey: "news_id")
        coder.encodeObject(self.title, forKey: "news_title")
        coder.encodeObject(self.slug, forKey: "news_slug")
        coder.encodeObject(self.publishedAt, forKey: "published_at")
        coder.encodeObject(self.shortDescription, forKey: "short_description")
        coder.encodeObject(self.imageURL, forKey: "image_preview")
        coder.encodeObject(self.postedBy, forKey: "posted_by")
        coder.encodeObject(self.categoryID, forKey: "category_id")
        coder.encodeObject(self.displayPostedBy, forKey: "display_posted_by")
        coder.encodeObject(self.updatedAt, forKey: "updated_at")
        
    }
    
    
}



class NewsList: NSObject, NSCoding {
    var list: [News]
    
    override init() {
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
    
    required convenience init?(coder decoder: NSCoder) {
        guard let news = decoder.decodeObjectForKey("list") as? [News]
            else { return nil }
        
        self.init(news: news)
    }
    
    init(news: [News]) {
        self.list = news
    }
    
    
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.list, forKey: "list")
    }
    
    
    
}
