//
//  RefreshKit.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/1/31.
//  Copyright © 2019 yy. All rights reserved.
//

import Foundation
import UIKit

// RefreshKit
public class RefreshKitWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/// Represents a type which is compatible with RefreshKit. You can use `rf` property to get a
/// value in the namespace of RefreshKit.
public protocol RefreshKitCompatible { }

public extension RefreshKitCompatible {
    
    /// Gets a namespace holder for RefreshKit compatible types.
    public var rf: RefreshKitWrapper<Self> {
        get { return RefreshKitWrapper(self) }
        set { }
    }
}

extension UIScrollView: RefreshKitCompatible { }
