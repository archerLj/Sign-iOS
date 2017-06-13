//
//  LFProfileViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/11.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

class LFProfileViewController: UIViewController {
    
    /***********************************************************/
    //MARK: Varibles -
    /***********************************************************/
    let cellResueID = "LFProfileCellID";
    @IBOutlet weak var mainTable: UITableView!
    lazy var headerView: LFProfileHeaderView = {
        $0.delegate = self;
        return $0;
    }(Bundle.main.loadNibNamed("LFProfileHeaderView", owner: self, options: nil)?.last as! LFProfileHeaderView)
    
    lazy var footerView: LFProfileFooterView = {
        $0.delegate = self;
        return $0;
    }(Bundle.main.loadNibNamed("LFProfileFooterView", owner: self, options: nil)?.last as! LFProfileFooterView)
    
    
    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人";
        self.mainTable.delegate = self;
        self.mainTable.dataSource = self;
        self.mainTable.register(UINib(nibName: "LFProfileCell", bundle: nil), forCellReuseIdentifier: cellResueID);
        self.mainTable.tableHeaderView = self.headerView;
        self.mainTable.tableFooterView = self.footerView;
        self.mainTable.separatorStyle = .none;
        
        self.headerView.nameLabel.text = LFUtils.userInfo?.name;
    }

}

extension LFProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellResueID) as! LFProfileCell;
        cell.selectionStyle = .none;
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = LFUtils.userInfo?.jobNum;
            break;
        case 1:
            cell.titleLabel.text = LFUtils.userInfo?.department?.name;
            break;
        case 2:
            cell.titleLabel.text = LFUtils.userInfo?.phoneNum;
            break;
        default:
            cell.titleLabel.text = LFUtils.userInfo?.position;
            break;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0;
    }
}

extension LFProfileViewController: LFProfileFooterViewDelegate {
    
    func LFProfileFooterView(view: LFProfileFooterView, logoutDidClicked: UIButton) {
        
        let actionSheetVC = UIAlertController(title: "", message: "退出后不会删除任何历史数据，下次登录依然可以使用本账号", preferredStyle: .actionSheet);
        
        let action1 = UIAlertAction(title: "退出登陆", style: .destructive) { (action) in
            
            LFUtils.removeUser();
            LFUtils.userInfo = nil;
            slocation = nil;
            saddress = nil;
            
            let storyboard = UIStoryboard.storybord(storybord: .loginASign);
            let loginVC: LFLoginViewController = storyboard.instantiateViewController();
            let baseNav = UINavigationController(rootViewController: loginVC);
            UIApplication.shared.keyWindow?.rootViewController = baseNav;
        }
        
        let action2 = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        
        actionSheetVC.addAction(action1);
        actionSheetVC.addAction(action2);
        self.present(actionSheetVC, animated: true, completion: nil);
    }
}

extension LFProfileViewController: LFProfileHeaderViewDelegate {
    
    func LFProfileHeaderView(view: LFProfileHeaderView, btnAction: UIButton) {
        
        let actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet);
        
        let action1 = UIAlertAction(title: "从相册选择", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController();
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                self.present(picker, animated: true, completion: nil);
            } else {
                LFUtils.showErrorHud(withMessage: "无法打开相册", onView: self.view);
            }
        }
        
        let action2 = UIAlertAction(title: "拍照", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController();
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceType.camera;
                picker.allowsEditing = true;
                self.present(picker, animated: true, completion: nil);
            } else {
                LFUtils.showErrorHud(withMessage: "无法打开相机", onView: self.view);
            }
        }
        
        let action3 = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        
        actionSheetVC.addAction(action1);
        actionSheetVC.addAction(action2);
        actionSheetVC.addAction(action3);
        self.present(actionSheetVC, animated: true, completion: nil);
    }
}

extension LFProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.headerView.postrait.image = image;
        picker.dismiss(animated: true, completion: nil);
    }
}
