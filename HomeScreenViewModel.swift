//
//  HomeScreenViewModel.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 16/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

typealias homeScreenResponseHandler = (HomeScreenViewModel) -> ()

class HomeScreenViewModel: NSObject {
    var topNewsList: NewsList?
    var karnatakaNewsList : NewsList?
    var specialNewsList: NewsList?
    static var totalDownloadedNews = 0
    static var expcetedNumberOfNews = 3
    override init() {
        
    }
    
    
    class func loadHomeScreenViewModelWithCompletionHandler(completionHandler: homeScreenResponseHandler) {
        totalDownloadedNews = 0
        let homeScreenViewModel = HomeScreenViewModel()

        let requestList : [BulletinRequest] = [.TopNews, .KarnatakaNews, .SpecialNews]
        
        for request in requestList {
            getHomeScreenNewsWithRequest(request) { (newsList) -> () in
                totalDownloadedNews++
                switch request {
                case .TopNews:
                    homeScreenViewModel.topNewsList = newsList
                    
                case .KarnatakaNews:
                    homeScreenViewModel.karnatakaNewsList = newsList
                    
                case .SpecialNews:
                    homeScreenViewModel.specialNewsList = newsList
                    
                default:
                    break
                }
                if totalDownloadedNews == expcetedNumberOfNews {
                    completionHandler(homeScreenViewModel)
                }
            }
            
        }
        
        
    }
    
    class func getHomeScreenNewsWithRequest(request: BulletinRequest, completionHandler: (NewsList) -> () ) {
        APIServiceManager.sharedInstance.getNews(request, completionHandler: { (result) -> Void in
            switch result {
            case .Success(let result):
                if let newsArray = result as? NSArray {
                    let specialNewsList = NewsList(newsArray: newsArray)
                    completionHandler(specialNewsList)
                }
            case .Failure:
                completionHandler(NewsList())
            }
            
        })
    }
    
    
}
