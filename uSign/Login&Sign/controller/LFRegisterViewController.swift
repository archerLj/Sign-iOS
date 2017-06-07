//
//  LFRegisterViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/6.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

class LFRegisterViewController: UIViewController {
    
    /***********************************************************/
    //MARK: Variables -
    /***********************************************************/
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var registerBtn: UIButton!
    

    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册";
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
    }

    

    
    
    /***********************************************************/
    //MARK: Private -
    /***********************************************************/
    @IBAction func registerAction(_ sender: UIButton) {
    }
    
}
