//
//  LFOutCommentViewController.swift
//  uSign
//
//  Created by archerLj on 2017/6/12.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

class LFOutCommentViewController: UIViewController {
    
    var event: LFEvent?
    @IBOutlet weak var comment: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "外出事由";
        self.comment.text = event?.comment;
    }

}
