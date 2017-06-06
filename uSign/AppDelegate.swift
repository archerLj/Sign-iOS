//
//  AppDelegate.swift
//  uSign
//
//  Created by archerLj on 2017/6/5.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.setNavigationAppear();
        
        let storyBoard = UIStoryboard.storybord(storybord: .loginASign);
        let loginVC: LFLoginViewController = storyBoard.instantiateViewController();
        let baseNav = UINavigationController(rootViewController: loginVC);
        
        window?.rootViewController = baseNav;
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    
    
    /***********************************************************/
    //MARK: private -
    /***********************************************************/
    func setNavigationAppear(){

        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0), NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName: UIColor.white], for: .normal)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.black;
        
        
        
        UIApplication.shared.statusBarStyle = .lightContent;
        UIApplication.shared.isStatusBarHidden = false;
    }
}

