//
//  LFSignFooterView.swift
//  uSign
//
//  Created by archerLj on 2017/6/11.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

protocol LFSignFooterViewDelegate {
    
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedOut: UIButton);
    func LFSignFooterViewDelegate(view: LFSignFooterView, didClickedSign: UIButton);
}

class LFSignFooterView: UIView {

    
    @IBOutlet weak var signBtn: UIButton!
    @IBOutlet weak var location: UILabel!
    var delegate: LFSignFooterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib();
        signBtn.layer.cornerRadius = 5.0;
    }
    
    
    @IBAction func outAction(_ sender: UIButton) {
        self.delegate?.LFSignFooterViewDelegate(view: self, didClickedOut: sender);
    }
    
    @IBAction func signAction(_ sender: UIButton) {
        self.delegate?.LFSignFooterViewDelegate(view: self, didClickedSign: sender);
    }
    
}
