//
//  APIServiceManager.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 13/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

class APIServiceManager: NSObject {
    
    static let baseURL = "http://api.newskarnataka.com:902"
    static let APIKey = "/api/v1"
    
    static let sharedInstance = APIServiceManager()
    
    var generalError : NSError {
        return NSError(domain: "com.bulletin", code:  0001, userInfo: nil)
    }
    
    var responseFieldUnavailable: NSError {
        return NSError(domain: "com.bulletin", code: 0002, userInfo: nil)
    }
    
    
    func checkTokenGenertaionAPIStatus(json: AnyObject) throws -> Result<AnyObject, NSError> {
        
        guard let jsonDict = json as? NSDictionary else {
            throw generalError
        }
        guard let token = jsonDict["data"] as? String, status = jsonDict["status"] as? Int else {
            throw responseFieldUnavailable
        }
        
        if token.isEmpty  {
            throw responseFieldUnavailable
        }
        
        if status != 200 {
            return Result.Failure(generalError)
        }
        return Result.Success(token)
        
    }
    
    
    func checkNewsAPIStatus(json: AnyObject) throws -> Result<AnyObject, NSError> {
        
        guard let jsonDict = json as? NSDictionary else {
            throw generalError
        }
        
        guard let data = jsonDict["data"] as? NSDictionary else {
            throw responseFieldUnavailable
        }
        
        guard let newsList = data["news_details"] as? NSArray else {
            throw responseFieldUnavailable
        }
        
        return Result.Success(newsList)
        
    }
    
    
    
    
    
    func generateTokenWithDeviceID(deviceID: String?, completionHandler: Result<AnyObject, NSError> -> Void) {
        if let deviceID = deviceID {
            request(BulletinRequest.TokenAPI(["X-APIKey":"6a7cde8450ac4cb47397a7d13792b0b27b67f36e65f1b6f7625885ec383507cc",
                "X-DeviceID":deviceID])).responseJSON { (response) -> Void in
                    switch response.result {
                    case .Success(let json):
                        do {
                            switch try self.checkTokenGenertaionAPIStatus(json) {
                            case .Success(let token):
                                completionHandler(Result.Success(token))
                            case .Failure(let error):
                                completionHandler(Result.Failure(error))
                            }
                        }catch (let error){
                            completionHandler(Result.Failure(error as NSError))
                        }
                        
                    case .Failure(let error):
                        completionHandler(Result.Failure(error))
                    }
            }
            
        } else {
            return completionHandler(Result.Failure(generalError))
        }
    }
    
    
    func appShouldProceed(completionHandler: Result<AnyObject, NSError> -> Void) {
        request(BulletinRequest.Intitiate).responseJSON { (response) -> Void in
            switch response.result {
                
            case .Success(let json):
                if let json = json as? NSDictionary {
                    if let status = json["status"] as? String {
                        status == "SUCCESS" ?  completionHandler(Result.Success(true)) :  completionHandler(Result.Success(false))
                        return
                    }
                }
                completionHandler(Result.Success(true))
                
            case .Failure(let error):
                
                completionHandler(Result.Failure(error))
            }
            
        }
    }
    
    
    func getNews(type: BulletinRequest, completionHandler: Result<AnyObject, NSError> -> Void) {
        
        var URLRequest: URLRequestConvertible!
        
        let defaultPaginagtion = PaginationTracker()
        switch type {
            
        case .TopNews(let paginationTracker):
            URLRequest = BulletinRequest.TopNews(paginationTracker)
            
        case .SpecialNews(let paginationTracker):
            URLRequest = BulletinRequest.SpecialNews(paginationTracker)
         
        case .commonNews(let paginationTracker, let category):
            URLRequest = BulletinRequest.commonNews(paginationTracker, category)
        default:
            URLRequest = BulletinRequest.KarnatakaNews(defaultPaginagtion)
        }
        
        perfromRequest(URLRequest, withCompletionHandler: completionHandler)
    }
    
    func getNewsForSubCategory(subCategory: String, completionHandler: Result<AnyObject, NSError> -> Void) {
        perfromRequest( BulletinRequest.commonNews(PaginationTracker(), subCategory), withCompletionHandler: completionHandler)
    }
    
    
    func perfromRequest(URLRequest:URLRequestConvertible, withCompletionHandler completionHandler: Result<AnyObject, NSError> -> Void) {
        
        request(URLRequest).responseJSON { (response) -> Void in
            switch response.result {
            case .Success(let json):
                do {
                    switch try self.checkNewsAPIStatus(json) {
                    case .Success(let newsDetails):
                        completionHandler(Result.Success(newsDetails))
                    case .Failure(let error):
                        completionHandler(Result.Failure(error))
                    }
                }catch (let error){
                    completionHandler(Result.Failure(error as NSError))
                }
                
            case .Failure(let error):
                completionHandler(Result.Failure(error))
            }
        }

    }
    
}
