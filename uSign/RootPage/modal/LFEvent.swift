//
//  LFEvent.swift
//  uSign
//
//  Created by archerLj on 2017/6/11.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import HandyJSON

class LFEvent: HandyJSON {
    
    var actionType: Int?/* 0: 签到 1:签退 2:外出*/
    var updateTime: String?
    var remark: String?
    var comment: String?
    
    required init() {}
}
