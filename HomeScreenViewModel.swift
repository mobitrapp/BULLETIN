//
//  HomeScreenViewModel.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 16/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

typealias homeScreenResponseHandler = (HomeScreenViewModel) -> ()

class HomeScreenViewModel: NSObject, NSCoding {
    var topNewsList: NewsList?
    var karnatakaNewsList : NewsList?
    var specialNewsList: NewsList?
    static var totalDownloadedNews = 0
    static var expcetedNumberOfNews = 3
    
    
    required convenience init?(coder decoder: NSCoder) {
        guard let topNewsList = decoder.decodeObjectForKey("topNewsList") as? NewsList,
            let karnatakaNewsList = decoder.decodeObjectForKey("karnatakaNewsList") as? NewsList,
            let specialNewsList = decoder.decodeObjectForKey("specialNewsList") as? NewsList
            else {
                return nil }
        
        self.init(topNewsList: topNewsList, karnatakaNewsList: karnatakaNewsList, specialNewsList: specialNewsList)
    }
    
    init(topNewsList: NewsList?, karnatakaNewsList: NewsList?, specialNewsList: NewsList?) {
        self.topNewsList = topNewsList
        self.karnatakaNewsList = karnatakaNewsList
        self.specialNewsList = specialNewsList
    }
    
    override init() {
        
    }
    
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.topNewsList, forKey: "topNewsList")
        coder.encodeObject(self.karnatakaNewsList, forKey: "karnatakaNewsList")
        coder.encodeObject(self.specialNewsList, forKey: "specialNewsList")
    }
    
    class func loadHomeScreenViewModelWithCompletionHandler(completionHandler: homeScreenResponseHandler) {
        totalDownloadedNews = 0
        let homeScreenViewModel = HomeScreenViewModel(topNewsList: nil, karnatakaNewsList: nil, specialNewsList: nil)
        let defaultPagination = PaginationTracker()
        let requestList : [BulletinRequest] = [.TopNews(defaultPagination), .KarnatakaNews(defaultPagination), .SpecialNews(defaultPagination)]
        
        for request in requestList {
            getNewsWithRequest(request) { (newsList) -> () in
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
                    
                    if homeScreenViewModel.newsIsAvailable() {
                        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(homeScreenViewModel)
                        NSUserDefaults.standardUserDefaults().setObject(encodedData, forKey: GlobalStrings.CachedHomeScreenModel.rawValue)
                    }
                    
                    completionHandler(homeScreenViewModel)
                }
            }
            
        }
    }
    
    class func getNewsWithRequest(request: BulletinRequest, completionHandler: (NewsList) -> () ) {
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
    
    
    func newsIsAvailable() -> Bool {
        if let topNewsList = topNewsList, let karnatakaNewsList = karnatakaNewsList , let specialNewsList = specialNewsList {
            if topNewsList.list.isEmpty && karnatakaNewsList.list.isEmpty && specialNewsList.list.isEmpty {
                return false
            }
        } else {
            return false
        }
        
        return true
    }
    
}
