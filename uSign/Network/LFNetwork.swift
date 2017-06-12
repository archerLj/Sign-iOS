//
//  Network.swift
//  uSign
//
//  Created by archerLj on 2017/6/6.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import Alamofire


let baseUrl: String = "https://192.168.1.171:8443";
//自签名网站地址
let selfSignedHosts = ["192.168.1.171"]
//定义一个结构体，存储认证相关信息
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}

class LFNetwork {
    
    // 注册
    class func register(name: String, jobNum: String, department: String, phone: String, position: String, paswd: String, fn: @escaping (LFUser?)->()) {
        
        let params = [
            "name": name,
            "jobNum": jobNum,
            "department": department,
            "phoneNum": phone,
            "position": position,
            "paswd": paswd
        ]
        
        commonRequest(params: params, url: "/api/addUser", method: .post) { (data) in
            if let tempData = data {
                if let objc = LFUser.deserialize(from: String(data: tempData, encoding: .utf8)) {
                    fn(objc);
                } else {
                    fn(nil);
                }
            } else {
                fn(nil)
            }
        }
    }
    
    //登录
    class func login(account: String, paswd: String, fn: @escaping (LFUser?)->()) {

        let params = [
            "account": account,
            "pswd": paswd
        ];
        
        commonRequest(params: params, url: "/api/login", method: .post) { (data: Data?) in
            
            if let tempData = data {
                if let objc = LFUser.deserialize(from: String(data: tempData, encoding: .utf8)) {
                    fn(objc);
                } else {
                    fn(nil);
                }
            } else {
                fn(nil)
            }
        }
    }
    
    //获取部门信息
    class func getDepartment(fn: @escaping ([LFDepartment?]?) -> ()) {
        
        commonRequest(params: [:], url: "/api/getAllDepartment", method: .get) { (data) in
            
            if let tempData = data {
                if let objc = [LFDepartment].deserialize(from: String(data: tempData, encoding: .utf8)) {
                    fn(objc);
                } else {
                    fn(nil);
                }
            } else {
                fn(nil)
            }
        }
    }
    
    //修改密码
    class func changePaswd(phoneNum: String, paswd: String, fn:@escaping (Bool)->()) {
        
        let params = [
            "phoneNum": phoneNum,
            "paswd": paswd
        ]
        
        commonRequest(params: params, url: "/api/changePaswd", method: .post) { (data) in
            let res = String(data: data!, encoding: .utf8);
            if let _ = res {
                if res == "0" {
                    fn(true);
                } else {
                    fn(false);
                }
            } else {
                fn(false);
            }
        }
    }
    
    // 当日Events
    class func getTodayEvents(fn: @escaping ([LFEvent?]?)->()) {
        
        
        commonRequest(params: ["userid": LFUtils.userInfo?.id ?? ""], url: "/api/getTodayEvents", method: .get) { (data) in
            
            if let tempData = data {
                if let objc = [LFEvent].deserialize(from: String(data: tempData, encoding: .utf8)) {
                    fn(objc);
                } else {
                    fn(nil);
                }
            } else {
                fn(nil)
            }

        }
    }
    
    // 签到/签退/外出
    class func addEvent(actionType: Int, latitude: Double, longtitude: Double, address: String, comment: String, fn: @escaping (Bool)->()) {
        
        let params = [
        "userid": (LFUtils.userInfo?.id)!,
        "actionType": actionType,
        "latitude": latitude,
        "longtitude": longtitude,
        "address": address,
        "comment": comment
        ] as [String : Any];
        
        commonRequest(params: params, url: "/api/addEvent", method: .post) { (data) in
            
            fn(true);
        }
    }
    
    
    /***********************************************************/
    //MARK: 网络请求入口
    /***********************************************************/
    class func commonRequest(params: Dictionary<String, Any>, url: String, method: HTTPMethod, completionHandler: @escaping (Data?) -> Void) {
        
        trastCer();
        
        Alamofire.request(baseUrl + url, method: method, parameters: params, encoding: URLEncoding.default).responseJSON { (res) in
            
            print(res);
            
            switch res.result {
            case .success:
                if let tempData = res.data {
                    completionHandler(tempData);
                } else {
                    completionHandler(nil);
                }
            case .failure:
                completionHandler(nil);
            }
        };
    }
    
    
    
    /***********************************************************/
    //MARK: 服务器证书认证
    /***********************************************************/
    class func trastCer() -> Void {
        //认证相关设置
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust
                && selfSignedHosts.contains(challenge.protectionSpace.host) {
                print("服务器认证！")
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                return (.useCredential, credential)
            }
                //认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:IdentityAndTrust = extractIdentity();
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
                
            } else { // 其它情况（不接受认证）
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    
    //获取客户端证书相关信息
    class func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "keystore", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "123456"] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                    trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
}


