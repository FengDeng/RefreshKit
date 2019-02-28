//
//  Refresher.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/25.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import EmptyKit

public enum RefreshState : Equatable{
    public static func == (lhs: RefreshState, rhs: RefreshState) -> Bool {
        switch (lhs,rhs) {
        case (.idle,.idle):
            return true
        case (.pulling,.pulling):
            return true
        case (.refreshing,.refreshing):
            return true
        case (.willRefresh,.willRefresh):
            return true
        case (.empty,.empty):
            return true
        default:
            return false
        }
    }
    
    case idle
    case pulling
    case refreshing
    case willRefresh
    case empty
    case error(Error)
}

public class Refresher {
    
    public static let `default` = Refresher()
    
    private init(){}
    
    public var placeViewEnable = true
    public var placeOffsetY : CGFloat = 0
    public var placeView : PlaceComponent?
    
    public var headerTime = AddRefreshComponentTime.successOnce
    public var footerTime = AddRefreshComponentTime.successOnce
    
    public var headerView : RefreshComponent = DefaultHeaderContainer()
    public var footerView : RefreshComponent = DefaultFooterContainer()
    
}
