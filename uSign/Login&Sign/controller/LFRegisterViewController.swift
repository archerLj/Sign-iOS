//
//  LFRegisterViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/6.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit
import PKHUD

class LFRegisterViewController: UIViewController {
    
    /***********************************************************/
    //MARK: Variables -
    /***********************************************************/
    let cellReuseId = "LFRegisterTableViewCellID"
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var registerBtn: UIButton!
    var placeHolders = ["姓名","工号","部门","电话号码","职位","登录密码","登录密码（确认）"]
    var userInfos = ["","","","","","",""]
    var validArr = [false,false,false,false,false,false,false]
    var mainTableFrame = CGRect.zero
    var departments: [LFDepartment?]?
    

    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册";
        viewSetting();
        getDepartment();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        mainTableFrame = mainTable.frame;
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardUp(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        NotificationCenter.default.removeObserver(self);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    
    // 这里通过修改tableView的高度+滚动cell来达到输入框不被键盘遮挡的效果
    func keyboardUp(notification: Notification) {
        
        let userInfo = notification.userInfo!;
        let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue;
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Float
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Float;
        
        
        self.mainTable.frame = CGRect(x: self.mainTable.frame.origin.x, y: self.mainTable.frame.origin.y, width: self.mainTable.bounds.size.width, height: self.mainTableFrame.size.height - (endFrame?.size.height)! - 69); //如果不-69，最后的cell会被遮挡
        // 这个动画是为了兼容第三方输入法，如果是系统的输入法直接改变他的ContentOffset即可，默认有动画，但是如果是第三方输入法动画就没有了，所以在这里用键盘的动画来进行弥补
        UIView.animate(withDuration: TimeInterval(duration)) {
            
            UIView.setAnimationBeginsFromCurrentState(true);
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve))!);
            
            if self.mainTable.contentSize.height > self.mainTable.frame.size.height {
                let offSet = CGPoint(x: 0, y: self.mainTable.contentSize.height - self.mainTable.bounds.size.height);
                // 这里的animated属性必须设置为NO（即不用系统的动画），否则会出现问题
                self.mainTable.setContentOffset(offSet, animated: false);
            }
        }
    }
    
    func keyboardDown(notification: Notification) {
        
        self.mainTable.frame = self.mainTableFrame;
    }

    

    
    
    /***********************************************************/
    //MARK: Private -
    /***********************************************************/
    func viewSetting(){
        
        self.registerBtn.layer.cornerRadius = self.registerBtn.bounds.size.width/2.0;
        self.registerBtn.layer.borderWidth = 1;
        
        self.mainTable.register(UINib(nibName: "LFRegisterTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseId);
        self.mainTable.delegate = self;
        self.mainTable.dataSource = self;
    }
    
    func getDepartment() {
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView();
        PKHUD.sharedHUD.show();
        
        LFNetwork.shared.getDepartment { (departments) in
            self.departments = departments;
            PKHUD.sharedHUD.hide();
        }
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        
        if  userInfos[5] != userInfos[6] {
            LFUtils.showErrorHud(withMessage: "密码不一致", onView: self.view);
        } else {
            var invalid = false;
            validArr.forEach({ (valide) in
                if !valide {
                    invalid = true
                }
            })
            if invalid {
                LFUtils.showErrorHud(withMessage: "输入有误", onView: self.view);
            } else {
                
                PKHUD.sharedHUD.contentView = PKHUDProgressView();
                PKHUD.sharedHUD.show();
                LFNetwork.shared.register(name: userInfos[0], jobNum: userInfos[1], department: userInfos[2], phone: userInfos[3], position: userInfos[4], paswd: userInfos[5],fn: { (user: LFUser?) in
                    if let _ = user {
                        LFUtils.userInfo = user;
                        PKHUD.sharedHUD.hide() { (res) in
                            HUD.flash(.success, onView: self.view, delay: 2.0, completion: { (res) in
                                self.navigationController?.popViewController(animated: true);
                            })
                        }
                    } else {
                        PKHUD.sharedHUD.hide() { (res) in
                            HUD.flash(.error);
                        }
                    }
                })
            }
        }
    }
}

extension LFRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolders.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) as! LFRegisterTableViewCell;
        cell.delegate = self;
        cell.placeHolder = placeHolders[indexPath.row];
        cell.valid = validArr[indexPath.row];
        cell.myText = userInfos[indexPath.row];
        cell.selectionStyle = .none;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
}

extension LFRegisterViewController: LFRegisterTableViewCellDelegate {

    func LFRegisterTableViewCell(cell: LFRegisterTableViewCell, didClickOnTextFiled: UITextField) {
        
        self.view.endEditing(true);
        
        let actionSheet = UIAlertController(title: "请选择部门", message: nil, preferredStyle: .actionSheet)
        
        self.departments?.forEach({ (department: LFDepartment?) in
            if let item = department {
                let action = UIAlertAction(title: item.name, style: .default) { (action) in
                    didClickOnTextFiled.text = item.name
                    self.userInfos[2] = item.name!;
                    self.validArr[2] = true;
                    self.mainTable.reloadData();
                }
                
                actionSheet.addAction(action);
            }
        })
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func LFRegisterTableViewCell(cell: LFRegisterTableViewCell, textFieldShouldReturn: UITextField) {
        
        let index = placeHolders.index(of: textFieldShouldReturn.placeholder!)!;
        if (textFieldShouldReturn.placeholder == "电话号码") {
            if LFUtils.isPhoneNumber(phoneNumber: textFieldShouldReturn.text!) {
                validArr[index] = true;
            } else {
                validArr[index] = false;
            }
        } else {
            if LFUtils.isEmptyString(item: textFieldShouldReturn.text) {
                validArr[index] = false;
            } else {
                validArr[index] = true;
            }
        }
        self.mainTable.reloadData();
        
        userInfos[index] = textFieldShouldReturn.text!
    }
}

