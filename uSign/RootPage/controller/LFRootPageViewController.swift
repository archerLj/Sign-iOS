//
//  LFRootPageViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/11.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import PKHUD


class LFRootPageViewController: UIViewController {
    
    /***********************************************************/
    //MARK: Variables -
    /***********************************************************/
    @IBOutlet weak var mainTable: UITableView!
    
    
    let cellReuseID = "LFSignCellID";
    var location: CLLocation?
    var address: String?
    let locationManager = AMapLocationManager()
    
    
    
    lazy var headerView = {
        return Bundle.main.loadNibNamed("LFSignHeaderView", owner: self, options: nil)?.last as! LFSignHeaderView;
    }()
    
    lazy var footerView: LFSignFooterView = {
        $0.delegate = self;
        return $0;
    }(Bundle.main.loadNibNamed("LFSignFooterView", owner: self, options: nil)?.last as! LFSignFooterView)


    
    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "首页";
        self.initSetting();
        self.getLocation();
    }

    
    /***********************************************************/
    //MARK: private -
    /***********************************************************/
    func initSetting() {
        
        self.mainTable.register(UINib(nibName: "LFSignCell", bundle: nil), forCellReuseIdentifier: cellReuseID);
        self.mainTable.tableHeaderView = self.headerView;
        self.mainTable.tableFooterView = self.footerView;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(self.getLocation));
        
        AMapServices.shared().apiKey = LFUtils.getGaodeKey();
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.locationTimeout = 10;
        locationManager.reGeocodeTimeout = 10;
    }
    
    func getLocation() {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        locationManager.requestLocation(withReGeocode: true) { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            PKHUD.sharedHUD.hide(true, completion: { (res) in
                
                if let _ = error {
                    LFUtils.showErrorHud(withMessage: "定位出错，点击右上角刷新重试", onView: self.view);
                }
                
                if let location = location {
                    self.location = location;
                }
                
                if let reGeocode = reGeocode {
                    self.address = reGeocode.formattedAddress;
                    self.footerView.location.text = self.address;
                }
            })
        }

    }
}


extension LFRootPageViewController: LFSignFooterViewDelegate {
    
    // 外出
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedOut: UIButton) {
        
    }
    
    // 签到/签退
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedSign: UIButton) {
        
    }
}
