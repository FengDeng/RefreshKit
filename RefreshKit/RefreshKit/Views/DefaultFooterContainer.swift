//
//  DefaultFooterContainer.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/26.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import UIKit

public class DefaultFooterContainer : UIView, RefreshComponent{
    public func onRefreshState(_ state: RefreshState) {
        print("footer:\(state)")
        self.label.text = "\(state)"
        switch state {
        case .idle:
            self.indicatorView.isHidden = true
            self.label.text = "上拉可以加载更多"
            break
        case .pulling:
            self.indicatorView.isHidden = true
            self.label.text = "松开立即加载更多"
            break
        case .refreshing:
            self.indicatorView.isHidden = false
            self.indicatorView.startAnimating()
            self.label.text = "正在加载更多的数据..."
            break
        case .willRefresh:
            self.indicatorView.isHidden = true
            self.label.text = "已经到底啦"
            break
        case .empty:
            self.indicatorView.isHidden = true
            self.label.text = "已经到底啦"
            break
        case .error(_):
            self.indicatorView.isHidden = true
            self.label.text = "出错啦,上拉重新加载"
            break
        }
    }
    
    public func onPullingPercent(_ percent: CGFloat) {
        print("footer-pullingPercent:\(percent)")
    }
    
    lazy var indicatorView : UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.style = UIActivityIndicatorView.Style.gray
        return v
    }()
    
    lazy var label : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = UIColor.lightGray
        l.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatorView.rightAnchor.constraint(equalTo: label.leftAnchor,constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
