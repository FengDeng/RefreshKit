//
//  RefreshComponent.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/28.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import  UIKit

open class RefreshComponent : UIView{
    
    public weak var rf : RefreshConfig? //弱引用一个 rf
    
    open var refreshState : RefreshState = .idle
    
    open var pullingPercent : CGFloat = 0
    
}
