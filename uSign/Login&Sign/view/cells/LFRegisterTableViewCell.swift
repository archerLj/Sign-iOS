//
//  LFRegisterTableViewCell.swift
//  uSign
//
//  Created by archerLj on 2017/6/7.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import UIKit

protocol LFRegisterTableViewCellDelegate {
    
    func LFRegisterTableViewCell(cell: LFRegisterTableViewCell, didClickOnTextFiled: UITextField)
    func LFRegisterTableViewCell(cell: LFRegisterTableViewCell, textFieldShouldReturn: UITextField)
}

class LFRegisterTableViewCell: UITableViewCell {
    
    /***********************************************************/
    //MARK: Variables -
    /***********************************************************/
    @IBOutlet weak var valideImageView: UIImageView!
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var departmentBtn: UIButton!
    var delegate: LFRegisterTableViewCellDelegate?
    var myText: String? {
        didSet {
            if let _ = myText {
                textFiled.text = myText;
            }
        }
    }
    var placeHolder: String? {
        didSet {
            if let _ = placeHolder {
                if placeHolder == "部门" {
                    departmentBtn.isHidden = false
                } else {
                    departmentBtn.isHidden = true
                }
                
                if placeHolder == "电话号码" || placeHolder == "工号" {
                    textFiled.keyboardType = .numberPad
                } else {
                    textFiled.keyboardType = .default
                }
                
                if placeHolder == "登录密码" || placeHolder == "登录密码（确认）" {
                    textFiled.isSecureTextEntry = true;
                } else {
                    textFiled.isSecureTextEntry = false;
                }
                
                textFiled.placeholder = placeHolder
            }
        }
    }
    
    var valid: Bool? {
        didSet {
            if let tempValid = valid {
                if tempValid {
                    self.valideImageView.image = UIImage(named: "valid_input")
                } else {
                    self.valideImageView.image = UIImage(named: "invalid_input")
                }
            }
        }
    }
    
    /***********************************************************/
    //MARK: LifeCycle -
    /***********************************************************/
    override func awakeFromNib() {
        textFiled.returnKeyType = .done
        textFiled.delegate = self
    }
    

    /***********************************************************/
    //MARK: private -
    /***********************************************************/
    @IBAction func departmentAction(_ sender: UIButton) {
        delegate?.LFRegisterTableViewCell(cell: self, didClickOnTextFiled: textFiled);
    }
}


extension LFRegisterTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.LFRegisterTableViewCell(cell: self, textFieldShouldReturn: textFiled)
        return textFiled.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.LFRegisterTableViewCell(cell: self, textFieldShouldReturn: textField)
    }
}
