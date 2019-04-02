//
//  UIScrollView+Config.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/26.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import UIKit

private var refreshConfigKey: Void?
extension UIScrollView{
    fileprivate var rf: RefreshConfig {
        set{
            newValue.scrollView = self
            objc_setAssociatedObject(self, &refreshConfigKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
        get{
            if let obj = objc_getAssociatedObject(self, &refreshConfigKey) as? RefreshConfig{
                obj.scrollView = self
                return obj
            }else{
                let a = RefreshConfig()
                a.scrollView = self
                objc_setAssociatedObject(self, &refreshConfigKey, a, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return a
            }
        }
    }
}

public extension RefreshKitWrapper where Base : UIScrollView{
    var config: RefreshConfig{
        return base.rf
    }
}

