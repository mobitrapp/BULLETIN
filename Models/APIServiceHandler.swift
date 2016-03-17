//
//  APIServiceHandler.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 13/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

enum BulletinRequest: URLRequestConvertible {
    
    case Intitiate
    case TokenAPI([String : String])
    case TopNews
    case KarnatakaNews
    case SpecialNews
    
    var requestMethod: Method {
        switch self {
        case .TokenAPI:
            return .POST
        case .TopNews, .Intitiate, .KarnatakaNews, .SpecialNews:
            return .GET
        }
        
    }
    
    var relativePath: String {
        switch self {
        case .Intitiate:
            return "https://dl.dropboxusercontent.com/s/1e9jl2e2bvoef45/app_status.json?dl=0"
        case .TokenAPI:
            return "auth"
        case .TopNews :
            return "api/v1/getCategoriesNews/CATEGORIES_TOP_NEWS"
        case .KarnatakaNews:
            return "api/v1/getSectionNews/SECTION_CITIES"
        case .SpecialNews:
            return "api/v1/getSectionNews/SECTION_SPECIAL?exclude_category=CATEGORIES_FROM_THE_WEB"
        }
    }
    
    var parameter: [String: AnyObject]? {
        return nil
    }
    
    var headers: [String: String]? {
        switch self {
        case .TokenAPI(let header):
            return header
            
        default:
            var deviceID = ""
            if let UUID = UIDevice.currentDevice().identifierForVendor?.UUIDString {
                deviceID = UUID
            }
            return ["X-Hash": NSUserDefaults.standardUserDefaults().objectForKey(GlobalStrings.APIToken.rawValue) as? String ?? "" ,
                "X-DeviceID": deviceID]
        }
    }
    
    
    var URLRequest: NSMutableURLRequest {
        let APIURL: String!
        
        switch self {
        case .Intitiate:
            APIURL = relativePath
        
        default:
            APIURL = APIServiceManager.baseURL+"/"+relativePath
        }
        
        let encodedURL = APIURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: encodedURL!)!)
        mutableURLRequest.HTTPMethod = requestMethod.rawValue
        
        if let headers = headers {
            for header in headers {
                mutableURLRequest.setValue(header.1, forHTTPHeaderField: header.0)
            }
            
        }
        
        return mutableURLRequest
    }
    
    
    
}
