//
//  User.swift
//  uSign
//
//  Created by archerLj on 2017/6/6.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import HandyJSON

class LFUser: HandyJSON {
    
    var id: Int?;
    var openid: String?;
    var name: String?;
    var jobNum: String?;
    var departmentid: Int?;
    var phoneNum: String?;
    var position: String?;
    var pswd: String?;
    var department: LFDepartment?
    
    required init() {};
}
