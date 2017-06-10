//
//  LFForgetPassworldViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/10.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

class LFForgetPassworldViewController: UIViewController {
    
    /***********************************************************/
    //MARK: Variables -
    /***********************************************************/
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var paswdField: UITextField!
    @IBOutlet weak var paswdAgainField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    

    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "找回密码"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }

    
    /***********************************************************/
    //MARK: Private -
    /***********************************************************/
    @IBAction func submitAction(_ sender: UIButton) {
    }
    
}
