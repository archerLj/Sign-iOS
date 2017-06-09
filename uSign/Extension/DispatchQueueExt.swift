//
//  DispatchQueueExt.swift
//  uSign
//
//  Created by archerLj on 2017/6/9.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import UIKit

extension DispatchQueue {
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}
