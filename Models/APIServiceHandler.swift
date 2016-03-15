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
    case TopNews([String : String])
    
    var requestMethod: Method {
        switch self {
        case .TokenAPI:
            return .POST
        case .TopNews, .Intitiate :
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
        }
    }
    
    var parameter: [String: AnyObject]? {
        return nil
    }
    
    var headers: [String: String]? {
        switch self {
        case .TokenAPI(let header):
            return header
        case .TopNews(let header):
            return header
        default:
            return nil
        }
    }
    
    
    var URLRequest: NSMutableURLRequest {
        let APIURL: NSURL!
        
        switch self {
        case .Intitiate:
            APIURL = NSURL(string: relativePath)!
        
        default:
            let URL = NSURL(string: APIServiceManager.baseURL)!
            APIURL = URL.URLByAppendingPathComponent(relativePath)
        }

        let mutableURLRequest = NSMutableURLRequest(URL: APIURL)
        mutableURLRequest.HTTPMethod = requestMethod.rawValue
        
        if let headers = headers {
            for header in headers {
                mutableURLRequest.setValue(header.1, forHTTPHeaderField: header.0)
            }
            
        }
        
        return mutableURLRequest
    }
    
    
    
}
