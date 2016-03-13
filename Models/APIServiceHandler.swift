//
//  APIServiceHandler.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 13/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

enum BulletinRequest: URLRequestConvertible {
    
    case TokenAPI([String : String])
    
    var requestMethod: Method {
        switch self {
        case .TokenAPI:
            return .POST
            //        default:
            //            return Method.GET
        }
        
    }
    
    var relativePath: String {
        switch self {
        case .TokenAPI:
            return "auth"
        }
    }
    
    var parameter: [String: AnyObject]? {
        return nil
    }
    
    var headers: [String: String]? {
        switch self {
        case .TokenAPI(let header):
            return header
        }
        return nil
    }
    
    
    var URLRequest: NSMutableURLRequest {
        
        let URL = NSURL(string: APIServiceManager.baseURL)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(relativePath))
        mutableURLRequest.HTTPMethod = requestMethod.rawValue
        
        if let headers = headers {
            for header in headers {
                mutableURLRequest.setValue(header.1, forHTTPHeaderField: header.0)
            }
            
        }
        
        return mutableURLRequest
    }
    
    
    
}
