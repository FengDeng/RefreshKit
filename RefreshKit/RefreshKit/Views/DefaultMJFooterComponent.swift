//
//  DefaultMJFooterComponent.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/26.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import MJRefresh

class DefaultMJFooterComponent: MJRefreshAutoFooter {
    
    let container : RefreshComponent
    init(container : RefreshComponent) {
        self.container = container
        super.init(frame: CGRect.zero)
        self.addSubview((self.container as! UIView))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //添加预加载的功能
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
        
        //如果手指已经离开 返回
        if !self.scrollView.isDragging{return}
        
        //如果是idle状态下  离底部距离满足条件，那就提前预加载
        guard let enable = self.container.refreshConfig?.preloadEnable,enable, case .idle = self.refreshState else{return}
        
        //如果不是上拉 返回
        guard let old = change["old"] as? CGPoint,let new = change["new"] as? CGPoint,new.y > old.y else{return}
        
        let distanceToBottom = self.scrollView.contentSize.height - (self.scrollView.contentOffset.y + scrollView.bounds.height) + self.scrollView.mj_insetT
        if distanceToBottom < (self.container.refreshConfig?.preloadMaxDistanceToBottom ?? UIScreen.main.bounds.height * 2){
            self.beginRefreshing()
        }
    }
    
    
    override func placeSubviews() {
        super.placeSubviews()
        (self.container as! UIView).frame = self.bounds
    }
    
    override var pullingPercent: CGFloat{
        didSet{
            self.container.onPullingPercent(pullingPercent)
        }
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
            self.container.onRefreshState(refreshState)
        }
    }
    
    override func beginRefreshing() {
        if self.state == .refreshing || self.refreshState == .empty{
            return
        }
        super.beginRefreshing()
    }
    
    internal override func endRefreshing() {
        super.endRefreshing()
    }
    
    func endRefreshingWithSuccess(){
        self.refreshState = .idle
        super.endRefreshing()
    }
    
    func endRefreshingWithEmpty() {
        self.refreshState = .empty
        super.endRefreshing()
    }
    func endRefreshingWithError(error:Error) {
        self.refreshState = .error(error)
        super.endRefreshing()
    }
    
}
