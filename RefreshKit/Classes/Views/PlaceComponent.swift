//
//  PlaceComponent.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/28.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import  UIKit

public enum PlaceState{
    case normal
    case refreshing
    case empty
    case error(Error)
}

open class PlaceComponent : UIView{
    
    public weak var rf : RefreshConfig? //弱引用一个 rf
    
    open var refreshState : RefreshState = .idle
    
    open var placeState : PlaceState = .normal
    
}
