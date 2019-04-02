//
//  Refreshable.swift
//  BaseKit
//
//  Created by 邓锋 on 2019/3/2.
//  Copyright © 2019 yy. All rights reserved.
//

import Foundation
import UIKit

public protocol Refreshable : class {
}

private var RefreshScrollViewKey: Void?
private var RefreshConfigViewKey: Void?
public extension Refreshable{
    
    public weak var scrollView : UIScrollView?{
        set{
            objc_setAssociatedObject(self, &RefreshScrollViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}
        get{
            return objc_getAssociatedObject(self, &RefreshScrollViewKey) as? UIScrollView
        }
    }
    public weak var refreshConfig : RefreshConfig?{
        set{
            objc_setAssociatedObject(self, &RefreshConfigViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)}
        get{
            return objc_getAssociatedObject(self, &RefreshConfigViewKey) as? RefreshConfig
        }
    }
}
