//
//  LFProfileHeaderView.swift
//  uSign
//
//  Created by archerLj on 2017/6/13.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

protocol LFProfileHeaderViewDelegate {
    func LFProfileHeaderView(view: LFProfileHeaderView, btnAction: UIButton)
}

class LFProfileHeaderView: UIView {

    @IBOutlet weak var postrait: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var delegate: LFProfileHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.postrait.clipsToBounds = true;
        self.postrait.layer.cornerRadius = self.postrait.bounds.size.height/2.0;
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        self.delegate?.LFProfileHeaderView(view: self, btnAction: sender);
    }
}
