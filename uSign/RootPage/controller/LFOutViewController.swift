//
//  LFOutViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/12.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import PKHUD

class LFOutViewController: UIViewController {

    
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var number: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "外出"
        self.commentView.layer.cornerRadius = 5.0;
        self.commentView.layer.borderWidth = 1.0;
        self.commentView.layer.borderColor = UIColor.lightGray.cgColor;
        self.commentView.becomeFirstResponder();
        self.commentView.delegate = self;
        
        self.commitBtn.layer.cornerRadius = 5.0;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    @IBAction func commitBtnAction(_ sender: UIButton) {
        
        if LFUtils.isEmptyString(item: self.commentView.text) {
            
            LFUtils.showErrorHud(withMessage: "外出事由不能为空", onView: self.view);
            return;
        }
        
        if let temp = slocation {
            
            PKHUD.sharedHUD.contentView = PKHUDProgressView();
            PKHUD.sharedHUD.show();
            
            LFNetwork.shared.addEvent(actionType: 2, latitude: temp.coordinate.latitude, longtitude: temp.coordinate.longitude, address: saddress!, comment: self.commentView.text) { (res) in
                PKHUD.sharedHUD.hide();
                
                let rootPageVC = self.navigationController?.viewControllers .first as! LFRootPageViewController;
                rootPageVC.getTodayEvents();
                self.navigationController?.popViewController(animated: true);
            }
        }
    }
    
}


extension LFOutViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if (textView.text.characters.count > 100) {
            let nsstrText =  textView.text! as NSString
            textView.text = nsstrText.substring(to: 100);
            textView.resignFirstResponder();
        }
        
        self.number.text = String.init(format: "%d/100", textView.text.characters.count)
    }
}
