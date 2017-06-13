//
//  LFProfileFooterView.swift
//  uSign
//
//  Created by archerLj on 2017/6/13.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

protocol LFProfileFooterViewDelegate {
    func LFProfileFooterView(view: LFProfileFooterView, logoutDidClicked: UIButton)
}

class LFProfileFooterView: UIView {
    
    var delegate: LFProfileFooterViewDelegate?

    @IBAction func logoutAction(_ sender: UIButton) {
        self.delegate?.LFProfileFooterView(view: self, logoutDidClicked: sender);
    }
    
}
