//
//  UITextFieldExt.swift
//  uSign
//
//  Created by archerLj on 2017/6/9.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import UIKit

//
//  UIViewControllerExt.swift
//  uSign
//
//  Created by archerLj on 2017/6/5.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    open override static func initialize() {
        struct Static {
            static var token = NSUUID().uuidString
        }
        
        if self != UITextField.self {
            return
        }
        
        DispatchQueue.once(token: Static.token) {
            let originalSelector = #selector(UITextField.awakeFromNib)
            let swizzledSelector = #selector(UITextField.xx_init)
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    func xx_init() {
        self.xx_init();
        self.inputAccessoryView = {
            let screenWidth = UIScreen.main.bounds.size.width;
            let toolView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 36.0));
            toolView.backgroundColor = UIColor.black;
            let closeBtn = UIButton(frame: CGRect(x: screenWidth - 50.0, y: 0, width: 50.0, height: 36.0));
            closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0);
            closeBtn.setTitle("完成", for: .normal);
            closeBtn.backgroundColor = UIColor.black;
            closeBtn.setTitleColor(UIColor.white, for: .normal);
            closeBtn.addTarget(self, action: #selector(self.textFieldDone), for: .touchUpInside);
            toolView.addSubview(closeBtn);
            return toolView;
        }()
    }
    
    func textFieldDone() {
        self.resignFirstResponder();
    }
}
