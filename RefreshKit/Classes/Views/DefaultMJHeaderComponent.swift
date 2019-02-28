//
//  DefaultMJHeaderComponent.swift
//  RefreshKit
//
//  Created by 邓锋 on 2019/2/26.
//  Copyright © 2019 kaixiaoke. All rights reserved.
//

import Foundation
import MJRefresh

extension MJRefreshState{
    var refreshState : RefreshState{
        switch self {
        case .idle:
            return RefreshState.idle
        case .pulling:
            return RefreshState.pulling
        case .refreshing:
            return RefreshState.refreshing
        case .willRefresh:
            return RefreshState.willRefresh
        case .noMoreData:
            return RefreshState.empty
        }
    }
}

class DefaultMJHeaderComponent : MJRefreshHeader{
    
    let container : RefreshComponent
    init(container : RefreshComponent) {
        self.container = container
        super.init(frame: CGRect.zero)
        self.addSubview(self.container)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func placeSubviews() {
        super.placeSubviews()
        self.container.frame = self.bounds
    }
    
    
    override var state: MJRefreshState{
        didSet{
            if oldValue == state{
                return
            }
            self.refreshState = state.refreshState
        }
    }
    
    var refreshState : RefreshState = .idle{
        didSet{
            self.container.refreshState = refreshState
        }
    }
    
    override func beginRefreshing() {
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
