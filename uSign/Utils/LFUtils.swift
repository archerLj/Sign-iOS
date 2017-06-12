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
                return true;
            }
            return false;
        } else {
            return true
        }
    }
    
    // 错误提示框
    class func showErrorHud(withMessage: String, onView: UIView) {
        HUD.flash(HUDContentType.labeledError(title: "错误提示", subtitle: withMessage), onView: onView, delay: 4.0, completion: nil);
    }
    
    class func saveUser() {
        UserDefaults.standard.setValue(userInfo?.phoneNum, forKey: "account");
        UserDefaults.standard.setValue(userInfo?.pswd, forKey: "password");
    }
    
    class func removeUser() {
        UserDefaults.standard.removeObject(forKey: "account");
        UserDefaults.standard.removeObject(forKey: "password");
    }
    
    class func getUserAccount() -> String? {
        return UserDefaults.standard.value(forKey: "account") as? String;
    }
    
    class func getUserPaswd() -> String? {
        return UserDefaults.standard.value(forKey: "password") as? String;
    }
    
    class func getGaodeKey() -> String {
        return "38ac9cbae61b7c0bcae149056d0eedd3";
    }
    
    class func getSMS_SDKAppKey() -> String {
        return "1e9eeb2831296";
    }
    
    class func getSMS_SDKAppSecret() -> String {
        return "be5407c89ce7fd44f11d62b3288674d2";
    }
}
