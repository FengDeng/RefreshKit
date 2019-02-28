//
//  DefaultMJFooterComponent.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/26.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import MJRefresh

class DefaultMJFooterComponent: MJRefreshBackFooter {
    
    let container : RefreshComponent
    init(container : RefreshComponent) {
        self.container = container
        super.init(frame: CGRect.zero)
        self.addSubview(self.container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    /*
    //contentSize变化 更新 footer的位置
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
        let contentHeight = self.scrollView.mj_contentH + self.ignoredScrollViewContentInsetBottom
        let scrollHeight = self.scrollView.mj_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom
        self.mj_y = [contentHeight,scrollHeight].max()!
    }*/
    
    
    override func placeSubviews() {
        super.placeSubviews()
        self.container.frame = self.bounds
    }
    
    
    override var state: MJRefreshState{
        didSet{
            if case .idle = refreshState{
                self.refreshState = state.refreshState
            }else{
                if state != .idle{
                    self.refreshState = state.refreshState
                }
            }
            
        }
    }
    
    var refreshState : RefreshState = .idle{
        didSet{
            self.container.refreshState = refreshState
        }
    }
    
    override func beginRefreshing() {
        if self.state == .refreshing{
            return
        }
        super.beginRefreshing()
    }
    
    internal override func endRefreshing() {
        super.endRefreshing()
    }
    
    func endRefreshingWithSuccess(){
        super.endRefreshing()
        self.refreshState = .idle
    }
    
    func endRefreshingWithEmpty() {
        super.endRefreshing()
        self.refreshState = .empty
    }
    func endRefreshingWithError(error:Error) {
        super.endRefreshing()
        self.refreshState = .error(error)
    }
    
}
