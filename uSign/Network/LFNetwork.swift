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

class Network {
    
    //登录
    class func login(account: String, paswd: String, fn: @escaping (LFUser?)->()) {
        
        trastCer();
        
        let params = [
            "account": account,
            "pswd": paswd
        ];
        
        Alamofire.request(baseUrl + "/api/login", method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { (res) in
            switch res.result {
            case .success:
                print(res);
                if let tempData = res.data {
                    if let objc = LFUser.deserialize(from: String(data: tempData, encoding: .utf8)) {
                        fn(objc);
                    } else {
                        fn(nil);
                    }
                } else {
                    fn(nil);
                }
            case .failure:
                fn(nil);
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


