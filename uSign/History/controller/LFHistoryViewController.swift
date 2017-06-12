//
//  LFHistoryViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/11.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import PKHUD

class LFHistoryViewController: UIViewController {
    
    let cellReuseID = "LFSignCellID"
    @IBOutlet weak var mainTable: UITableView!
    lazy var events = {
        return $0;
    }(Array<LFEvent>())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "签到记录";
        self.initSetting();
        self.getHistoryEvents();
    }
    
    func initSetting() {
        
        self.mainTable.register(UINib(nibName: "LFSignCell", bundle: nil), forCellReuseIdentifier: cellReuseID);
        self.mainTable.separatorStyle = .none;
        self.mainTable.delegate = self;
        self.mainTable.dataSource = self;
    }
    
    func getHistoryEvents() {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        LFNetwork.getHistoryEvents { (events) in
            
            PKHUD.sharedHUD.hide();
            
            if let _ = events {
                events?.forEach({ (event) in
                    if let _ = event {
                        self.events.append(event!);
                    }
                })
                self.mainTable.reloadData();
            }
        }
    }

}

extension LFHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) as! LFSignCell;
        let event = self.events[indexPath.row];
        cell.event = event;
        if event.actionType == 2 {
            cell.arrowImageView.isHidden = false;
        } else {
            cell.arrowImageView.isHidden = true;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let event = self.events[indexPath.row];
        if event.actionType == 2 {
            let storyboard = UIStoryboard.storybord(storybord: .History);
            let outCommentVC: LFOutCommentViewController = storyboard.instantiateViewController();
            outCommentVC.event = event;
            self.navigationController?.pushViewController(outCommentVC, animated: true);
        }
    }
}
