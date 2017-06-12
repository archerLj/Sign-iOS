//
//  LFForgetPassworldViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/10.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import PKHUD

class LFForgetPassworldViewController: UIViewController {
    
    /***********************************************************/
    //MARK: Variables -
    /***********************************************************/
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var paswdField: UITextField!
    @IBOutlet weak var paswdAgainField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var getCodeBtn: UIButton!
    
    
    

    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "找回密码"
        self.viewSetting();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil);
    }

    
    /***********************************************************/
    //MARK: Private -
    /***********************************************************/
    func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo!;
        let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue;
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Float
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Float;
        
        let paswdFieldEndFrame = paswdAgainField.frame.origin.y + paswdAgainField.bounds.size.height;
        if self.view.bounds.size.height - paswdFieldEndFrame < (endFrame?.size.height)! {
            
            let offSetY = (endFrame?.size.height)! - (self.view.bounds.size.height - paswdFieldEndFrame);
            self.view.transform = CGAffineTransform.init(translationX: 0, y: -offSetY);
            // 这个动画是为了兼容第三方输入法，如果是系统的输入法直接改变他的ContentOffset即可，默认有动画，但是如果是第三方输入法动画就没有了，所以在这里用键盘的动画来进行弥补
            UIView.animate(withDuration: TimeInterval(duration)) {
                
                UIView.setAnimationBeginsFromCurrentState(true);
                UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve))!);
            }
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        self.view.transform = CGAffineTransform.identity;
    }
    
    func viewSetting() {
        
        submitBtn.layer.cornerRadius = 5.0;
        paswdField.returnKeyType = .done;
        paswdAgainField.returnKeyType = .done;
        paswdAgainField.delegate = self;
        paswdField.delegate = self;
        
        self.getCodeBtn.layer.cornerRadius = 5.0;
        self.getCodeBtn.layer.borderColor = UIColor.black.cgColor;
        self.getCodeBtn.layer.borderWidth = 1;
    }
    
    @IBAction func getCodeAction(_ sender: UIButton) {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        if let _ = self.phoneNumField.text {
            SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: self.phoneNumField.text!, zone: "86", customIdentifier: nil) { (error) in
                
                PKHUD.sharedHUD.hide(true, completion: { (res) in
                    if let _ = error {
                        LFUtils.showErrorHud(withMessage: "发送失败", onView: self.view);
                    } else {
                        HUD.flash(.success, delay: 2.0);
                    }
                })
            }
        } else {
            LFUtils.showErrorHud(withMessage: "电话号码不正确", onView: self.view);
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if !LFUtils.isPhoneNumber(phoneNumber: phoneNumField.text!) {
            LFUtils.showErrorHud(withMessage: "电话号码有误", onView: self.view);
            return;
        }
        
        if LFUtils.isEmptyString(item: paswdField.text!) || LFUtils.isEmptyString(item: paswdAgainField.text!) {
            LFUtils.showErrorHud(withMessage: "密码不能为空", onView: self.view);
            return;
        }
        
        if paswdField.text! != paswdAgainField.text! {
            LFUtils.showErrorHud(withMessage: "密码不一致", onView: self.view);
            return;
        }
        
        if LFUtils.isEmptyString(item: codeField.text) {
            LFUtils.showErrorHud(withMessage: "验证码不能为空", onView: self.view);
            return;
        }
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        SMSSDK.commitVerificationCode(self.codeField.text, phoneNumber: self.phoneNumField.text, zone: "86") { (userInfo, error) in
            
            if let _ = error {
                PKHUD.sharedHUD.hide(true, completion: { (res) in
                    LFUtils.showErrorHud(withMessage: "验证码错误", onView: self.view);
                })
            } else {
                LFNetwork.changePaswd(phoneNum: self.phoneNumField.text!, paswd: self.paswdField.text!) { (res) in
                    
                    if res {
                        PKHUD.sharedHUD.hide() { (res) in
                            HUD.flash(.success, onView: self.view, delay: 2.0, completion: { (res) in
                                self.navigationController?.popViewController(animated: true);
                            })
                        }
                    } else {
                        PKHUD.sharedHUD.hide() { (res) in
                            LFUtils.showErrorHud(withMessage: "修改失败，请重试", onView: self.view)
                        }
                    }
                }
            }
        }
    }
    
}


extension LFForgetPassworldViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder();
    }
}
