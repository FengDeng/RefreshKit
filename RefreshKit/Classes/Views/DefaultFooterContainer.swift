//
//  DefaultFooterContainer.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/26.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import UIKit

public class DefaultFooterContainer : RefreshComponent{
    
    override public var refreshState: RefreshState{
        didSet{
            print("footer:\(refreshState)")
            self.label.text = "\(refreshState)"
        }
    }
    public override var pullingPercent: CGFloat{
        didSet{
            print("footer-pullingPercent:\(pullingPercent)")
        }
    }
    
    lazy var label : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.black
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       self.addSubview(label)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
