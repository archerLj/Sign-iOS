//
//  LoginViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/5.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import PKHUD

class LFLoginViewController: UIViewController {
    
    /**********LFLoginViewController*************************************************/
    //MARK: Variables -
    /***********************************************************/
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var accountLine: UIView!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var pswdLine: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    

    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewSetting();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if let _ = LFUtils.userInfo {
            self.accountField.text = LFUtils.userInfo?.phoneNum;
            self.pswdField.text = LFUtils.userInfo?.pswd;
            self.loginAction(loginBtn);
        } else {
            if let _ = LFUtils.getUserAccount() {
                self.accountField.text = LFUtils.getUserAccount();
                self.pswdField.text = LFUtils.getUserPaswd();
                self.loginAction(loginBtn);
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true);
    }
    

    
    /***********************************************************/
    //MARK: Private -
    /***********************************************************/
    private func viewSetting() {
        
        accountField.delegate = self;
        accountField.returnKeyType = .done;
        pswdField.delegate = self;
        pswdField.returnKeyType = .done;
        
        loginBtn.layer.borderColor = UIColor.black.cgColor;
        loginBtn.layer.borderWidth = 1;
        loginBtn.layer.cornerRadius = 5;
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        LFNetwork.login(account: accountField.text!, paswd: pswdField.text!, fn: { user in
            if let _ = user {
                LFUtils.userInfo = user;
                LFUtils.saveUser();
                PKHUD.sharedHUD.hide() { (res) in
                    HUD.flash(.success, onView: self.view, delay: 2.0, completion: { (res) in
                        let storyboard = UIStoryboard.storybord(storybord: .loginASign);
                        let mainTableVC: UITabBarController = storyboard.instantiateViewController();
                        UIApplication.shared.keyWindow?.rootViewController = mainTableVC;
                    })
                }
            } else {
                PKHUD.sharedHUD.hide() { (res) in
                    HUD.flash(.error);
                }
            }
        })
    }
    
    @IBAction func signAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.storybord(storybord: .loginASign);
        let registerVC: LFRegisterViewController = storyboard.instantiateViewController();
        self.navigationController?.pushViewController(registerVC, animated: true);
    }
    
    @IBAction func forgetPswdAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.storybord(storybord: .loginASign);
        let forgetPaswdVC: LFForgetPassworldViewController = storyboard.instantiateViewController();
        self.navigationController?.pushViewController(forgetPaswdVC, animated: true);
    }
}

extension LFLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountField {
            accountLine.backgroundColor = UIColor.black;
            pswdLine.backgroundColor = UIColor.lightGray;
        } else {
            accountLine.backgroundColor = UIColor.lightGray;
            pswdLine.backgroundColor = UIColor.black;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountField {
            accountLine.backgroundColor = UIColor.lightGray;
        } else {
            pswdLine.backgroundColor = UIColor.lightGray;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder();
    }
}
