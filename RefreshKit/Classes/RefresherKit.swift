//
//  RefresherKit.swift
//  kaixiaoke
//
//  Created by 邓锋 on 2018/12/11.
//  Copyright © 2018 zhiyin. All rights reserved.
//

import Foundation
import UIKit

// Refresher
public class RefresherWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents a type which is compatible with Refresher. You can use `rf` property to get a
/// value in the namespace of Refresh.
public protocol RefresherCompatible { }

public extension RefresherCompatible {
    
    /// Gets a namespace holder for Refresh compatible types.
    public var rf: RefresherWrapper<Self> {
        get { return RefresherWrapper(self) }
        set { }
    }
}

extension UIScrollView: RefresherCompatible { }
