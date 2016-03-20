//
//  UIViewController+Bulletin.swift
//  Bulletin
//
//  Created by Shailesh Chandavar on 20/03/16.
//  Copyright © 2016 com.Mobitrapp. All rights reserved.
//

import UIKit

extension UIViewController {

    func interNetIsAvailable() -> Bool {
        let newtworkReachability = Reach()
        var status = false
        switch newtworkReachability.connectionStatus() {
        case .Online:
            status = true
        default:
            status = false
        }
        return status
    }

}
