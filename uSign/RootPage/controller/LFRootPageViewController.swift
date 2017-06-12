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
    var todayEvents: [LFEvent] = []
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
        self.getTodayEvents();
        self.getLocation();
    }

    
    /***********************************************************/
    //MARK: private -
    /***********************************************************/
    func initSetting() {
        
        self.mainTable.register(UINib(nibName: "LFSignCell", bundle: nil), forCellReuseIdentifier: cellReuseID);
        self.mainTable.tableHeaderView = self.headerView;
        self.mainTable.tableFooterView = self.footerView;
        self.mainTable.delegate = self;
        self.mainTable.dataSource = self;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(self.getLocation));
        
        AMapServices.shared().apiKey = LFUtils.getGaodeKey();
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.locationTimeout = 10;
        locationManager.reGeocodeTimeout = 10;
        
        self.headerView.userName.text = LFUtils.userInfo?.name;
        self.headerView.jobNum.text = LFUtils.userInfo?.jobNum;
        self.headerView.departmentAPosition.text = (LFUtils.userInfo?.department?.name)! + " " + (LFUtils.userInfo?.position)!;
    }
    
    func getLocation() {
        
        locationManager.requestLocation(withReGeocode: true) { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
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
        }

    }
    
    func getTodayEvents() {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        LFNetwork.getTodayEvents { (events) in
            
            PKHUD.sharedHUD.hide();
            
            self.todayEvents.removeAll();
            
            if let _ = events {
                events!.forEach({ (event) in
                    if let _ = event {
                        self.todayEvents.append(event!);
                    }
               })
                self.mainTable.reloadData();
                
                // 设置提交按钮名称
                if events?.count == 0 {
                    self.footerView.signBtn.setTitle("签到", for: .normal);
                } else {
                    var signIned = 0;
                    var signOuted = 0;
                    
                    events?.forEach({ (event) in
                        if (event?.actionType == 0) { //签到过
                            signIned = 1;
                        } else if (event?.actionType == 1) { //签退过
                            signOuted = 1
                        }
                    })
                    
                    if (signIned == 0) {
                        self.footerView.signBtn.setTitle("签到", for: .normal);
                    } else if (signIned == 1 && signOuted == 0) {
                        self.footerView.signBtn.setTitle("签退", for: .normal);
                    } else {
                        self.footerView.signBtn.setTitle("签退", for: .normal);
                    }
                }
            }
        }
    }
}


extension LFRootPageViewController: LFSignFooterViewDelegate {
    
    // 外出
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedOut: UIButton) {
        
    }
    
    // 签到/签退
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedSign: UIButton) {
        
        if let temp = self.location {
            var actionType = 0;
            if self.footerView.signBtn.titleLabel?.text == "签退" {
                actionType = 1;
            }
            
            PKHUD.sharedHUD.contentView = PKHUDProgressView();
            PKHUD.sharedHUD.show();
            
            LFNetwork.addEvent(actionType: actionType, latitude: temp.coordinate.latitude, longtitude: temp.coordinate.longitude, address: self.address!, comment: "") { (res) in
                PKHUD.sharedHUD.hide();
                self.getTodayEvents();
            }
        }
    }
}


extension LFRootPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.todayEvents.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) as! LFSignCell;
        cell.event = self.todayEvents[indexPath.row];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;
    }
}
