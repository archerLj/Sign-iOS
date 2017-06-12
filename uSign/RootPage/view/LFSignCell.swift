//
//  LFSignCell.swift
//  uSign
//
//  Created by archerLj on 2017/6/11.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

class LFSignCell: UITableViewCell {
    
    
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventState: UILabel!
    
    var event: LFEvent? {
        didSet {
            if let _ = event {
                switch (event!.actionType)! {/* 0: 签到 1:签退 2:外出*/
                case 0:
                    eventType.text = "签到";
                    break;
                case 1:
                    eventType.text = "签退";
                    break;
                default:
                    eventType.text = "外出";
                    break;
                }
                
                eventTime.text = event!.updateTime;
                eventState.text = event!.remark;
                if (event!.remark == "迟到" || event!.remark == "早退" || event!.remark == "额外时间") {
                    eventState.textColor = UIColor.red;
                } else {
                    eventState.textColor = UIColor(red: 102.0, green: 102.0, blue: 102.0, alpha: 1.0);
                }
            }
        }
    }
}
