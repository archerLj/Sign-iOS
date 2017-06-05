//
//  StoryboardExt.swift
//  uSign
//
//  Created by archerLj on 2017/6/5.
//  Copyright © 2017年 com.bocodo.csr. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case loginASign
    }
    
    class func storybord(storybord: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        
        return UIStoryboard(name: storybord.rawValue, bundle: bundle);
    }
    
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        
        let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier);
        guard let viewController = optionalViewController as? T else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardIdentifier) ");
        }
        
        return viewController;
    }
}
