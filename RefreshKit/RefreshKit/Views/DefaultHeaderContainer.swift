//
//  DefaultHeaderContainer.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/26.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import UIKit

public class DefaultHeaderContainer : UIView,RefreshComponent{
    public func onRefreshState(_ state: RefreshState) {
        print("header:\(state)")
        self.label.text = "\(state)"
        
        switch state {
        case .idle:
            self.label.text = "下拉可以刷新"
            break
        case .pulling:
            self.label.text = "松开立即刷新"
            break
        case .refreshing:
            self.label.text = "正在刷新数据中..."
            break
        case .willRefresh:
            break
        case .empty:
            break
        case .error(_):
            break
        }
    }
    
    public func onPullingPercent(_ percent: CGFloat) {
        print("header-pullingPercent:\(percent)")
    }
    
    lazy var label : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.c_9
        l.font = UIFont.f_30
        l.textAlignment = .center
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
