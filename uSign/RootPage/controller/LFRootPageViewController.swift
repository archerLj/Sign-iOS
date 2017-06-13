//
//  LFRootPageViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/11.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import PKHUD


var slocation: CLLocation?
var saddress: String?

class LFRootPageViewController: UIViewController {
    
    /***********************************************************/
    //MARK: Variables -
    /***********************************************************/
    @IBOutlet weak var mainTable: UITableView!
    let cellReuseID = "LFSignCellID";
    
    lazy var todayEvents = {
        return $0;
    }(Array<LFEvent>())
    
    lazy var locationManager = {
        return $0;
    } (AMapLocationManager())
    
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
        self.mainTable.separatorStyle = .none;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "reLoaction"), style: .plain, target: self, action: #selector(self.getLocation))
        
        AMapServices.shared().apiKey = LFUtils.getGaodeKey();
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.locationTimeout = 10;
        locationManager.reGeocodeTimeout = 10;
        
        self.headerView.userName.text = LFUtils.userInfo?.name;
        self.headerView.jobNum.text = LFUtils.userInfo?.jobNum;
        self.headerView.departmentAPosition.text = (LFUtils.userInfo?.department?.name)! + " " + (LFUtils.userInfo?.position)!;
    }
    
    func getLocation() {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        locationManager.requestLocation(withReGeocode: true) { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            PKHUD.sharedHUD.hide();
            
            if let _ = error {
                LFUtils.showErrorHud(withMessage: "定位出错，点击右上角刷新重试", onView: self.view);
            }
            
            if let location = location {
                slocation = location;
            }
            
            if let reGeocode = reGeocode {
                saddress = reGeocode.formattedAddress;
                self.footerView.location.text = saddress;
            }
        }
    }
    
    func getTodayEvents() {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        LFNetwork.shared.getTodayEvents { (events) in
            
            PKHUD.sharedHUD.hide(true, completion: { (res) in
                if let _ = slocation {} else {
                    self.getLocation();
                }
            })
            
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
                        self.footerView.signBtn.isEnabled = false;
                    }
                }
            }
        }
    }
}


extension LFRootPageViewController: LFSignFooterViewDelegate {
    
    // 外出
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedOut: UIButton) {
    
        let storyboard = UIStoryboard.storybord(storybord: .RootPage)
        let outVC: LFOutViewController = storyboard.instantiateViewController();
        self.navigationController?.pushViewController(outVC, animated: true);
    }
    
    // 签到/签退
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedSign: UIButton) {
        
        if let temp = slocation {
            var actionType = 0;
            if self.footerView.signBtn.titleLabel?.text == "签退" {
                actionType = 1;
            }
            
            PKHUD.sharedHUD.contentView = PKHUDProgressView();
            PKHUD.sharedHUD.show();
            
            LFNetwork.shared.addEvent(actionType: actionType, latitude: temp.coordinate.latitude, longtitude: temp.coordinate.longitude, address: saddress!, comment: "") { (res) in
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
        cell.arrowImageView.isHidden = true;
        cell.selectionStyle = .none;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;
    }
}
