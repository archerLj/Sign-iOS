//
//  LFUtils.swift
//  uSign
//
//  Created by archerLj on 2017/6/9.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import PKHUD

class LFUtils {
    
    static var userInfo: LFUser?
    
    // 判断是否是电话号码
    class func isPhoneNumber(phoneNumber: String) -> Bool {
    
        if phoneNumber.characters.count == 0 {
            return false
        }
        let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        } else{
            return false
        }
    }
    
    // 判断是否是空字符串
    class func isEmptyString(item: String?) -> Bool {
       
        if let temp = item {
            let whiteSpace = NSCharacterSet.whitespacesAndNewlines;
            let str = temp.trimmingCharacters(in: whiteSpace);
            if str == "" {
                return false;
            }
            return true;
        } else {
            return false
        }
    }
    
    class func showErrorHud(withMessage: String, onView: UIView) {
        HUD.flash(HUDContentType.labeledError(title: "错误提示", subtitle: withMessage), onView: onView, delay: 4.0, completion: nil);
    }
}
