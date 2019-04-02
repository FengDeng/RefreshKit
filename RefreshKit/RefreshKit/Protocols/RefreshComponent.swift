//
//  RefreshComponent.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/28.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import  UIKit

public protocol RefreshComponent : Refreshable&UIView{
    func onRefreshState(_ state:RefreshState)
    func onPullingPercent(_ percent:CGFloat)
    init()
}
