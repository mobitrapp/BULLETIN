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
    
    
    func checkAPIStatus(json: AnyObject) throws -> Result<AnyObject, NSError> {
        
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
    
    
    
    
    func generateTokenWithDeviceID(deviceID: String?, completionHandler: Result<AnyObject, NSError> -> Void) {
        if let deviceID = deviceID {
            request(BulletinRequest.TokenAPI(["X-APIKey":"6a7cde8450ac4cb47397a7d13792b0b27b67f36e65f1b6f7625885ec383507cc",
                "X-DeviceID":deviceID])).responseJSON { (response) -> Void in
                    switch response.result {
                    case .Success(let json):
                        do {
                            switch try self.checkAPIStatus(json) {
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
    
    
}
