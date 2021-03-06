//
//  RefreshConfig.swift
//  kaixiaoke
//
//  Created by 邓锋 on 2019/1/24.
//  Copyright © 2019 zhiyin. All rights reserved.
//

import Foundation
import EmptyKit

public enum AddRefreshComponentTime{
    case always
    case never
    case successOnce //刷新成功一次后
}

public class RefreshConfig{
    
    weak var scrollView : UIScrollView?{
        didSet{
            self.placeView?.scrollView = self.scrollView
        }
    }
    
    public var placeOffsetY : CGFloat = Refresher.default.placeOffsetY
    public var placeViewEnable = Refresher.default.placeViewEnable
    public var placeAllowScroll = Refresher.default.placeAllowScroll
    public var placeView : PlaceComponent? = Refresher.default.placeView?.init(){
        didSet{
            placeView?.refreshConfig = self
        }
    }
    
    public var headerView : RefreshComponent  = Refresher.default.headerView.init()
    public var footerView : RefreshComponent = Refresher.default.footerView.init()
    
    public var headerBlock : (()->Void)?
    public var footerBlock : (()->Void)?
    
    public var preloadEnable = Refresher.default.preloadEnable
    public var preloadMaxDistanceToBottom : CGFloat = Refresher.default.preloadMaxDistanceToBottom
    
    public var headerTime = Refresher.default.headerTime
    public var footerTime = Refresher.default.footerTime
    
    var isHeaderRefreshing = false
    var isFooterRefreshing = false
    
    var placeState : PlaceState = .normal{
        didSet{
            print("placeState:\(placeState)")
            self.placeView?.onPlaceState(placeState)
            self.scrollView?.ept.reloadData()
        }
    }
    
    init() {
        self.placeView?.refreshConfig = self
    }
}

extension RefreshConfig : EmptyDataSource{
    public func customViewForEmpty(in view: UIView) -> UIView? {
        if !placeViewEnable{return nil}
        return self.placeView
    }
}
extension RefreshConfig : EmptyDelegate{
    public func verticalOffsetForEmpty(in view: UIView) -> CGFloat {
        return self.placeOffsetY
    }
    
    public func emptyShouldAllowScroll(in view: UIView) -> Bool {
        return placeAllowScroll
    }
}


extension RefreshConfig{
    
    //头部开始刷新
    public func headerBeginRefreshing(){
        //去除footer
        self.scrollView?.mj_footer = nil
        
        if self.placeViewEnable,self.scrollView?.ept.dataSource == nil{
            self.scrollView?.ept.dataSource = self
            self.scrollView?.ept.delegate = self
        }
        
        //判断有没下拉刷新
        guard let headerBlock = self.headerBlock else{return}
        
        //看看需不需要添加header
        if self.headerTime == .always{
            self.addMJHeader()
        }
        if self.footerTime == .always{
            self.addMJFooter()
        }
        
        //判断有无header
        guard let header = self.scrollView?.mj_header else{
            self.isHeaderRefreshing = true
            self.placeState = .refreshing
            headerBlock()
            return
        }
        //有header的时候 在 刷新block里面添加了设置placeState，所以这里不需要设置了
        header.beginRefreshing()
    }
    
    public func headerEndRefreshingWithSuccess(){
        self.isHeaderRefreshing = false
        self.placeState = .normal
        (self.scrollView?.mj_header as? DefaultMJHeaderComponent)?.endRefreshingWithSuccess()
        if self.headerTime == .successOnce{
            self.addMJHeader()
        }
        if self.footerTime == .successOnce{
            self.addMJFooter()
        }
    }
    
    public func headerEndRefreshingWithEmpty(emptyMsg:String){
        self.isHeaderRefreshing = false
        self.placeState = .empty(emptyMsg)
        (self.scrollView?.mj_header as? DefaultMJHeaderComponent)?.endRefreshingWithEmpty()
    }
    public func headerEndRefreshingWithError(error:Error){
        self.isHeaderRefreshing = false
        self.placeState = .error(error)
        (self.scrollView?.mj_header as? DefaultMJHeaderComponent)?.endRefreshingWithError(error: error)
    }
    
    
    public func footerBeginRefreshing(){
        guard let footerBlock = self.footerBlock else{return}
        guard let footer = self.scrollView?.mj_footer else{
            self.isFooterRefreshing = true
            footerBlock()
            return
        }
        footer.beginRefreshing()
    }
    public func footerEndRefreshingWithSuccess(){
        self.isFooterRefreshing = false
        (self.scrollView?.mj_footer as? DefaultMJFooterComponent)?.endRefreshingWithSuccess()
    }
    
    public func footerEndRefreshingWithEmpty(){
        self.isFooterRefreshing = false
        (self.scrollView?.mj_footer as? DefaultMJFooterComponent)?.endRefreshingWithEmpty()
    }
    public func footerEndRefreshingWithError(error:Error){
        self.isFooterRefreshing = false
        (self.scrollView?.mj_footer as? DefaultMJFooterComponent)?.endRefreshingWithError(error: error)
    }
    
    
    public func endRefreshingWithSuccess(){
        if self.isHeaderRefreshing{
            self.headerEndRefreshingWithSuccess()
        }else{
            self.placeState = .normal
        }
        if self.isFooterRefreshing{
            self.footerEndRefreshingWithSuccess()
        }
    }
    public func endRefreshingWithEmpty(emptyMsg:String){
        if self.isHeaderRefreshing{
            self.headerEndRefreshingWithEmpty(emptyMsg: emptyMsg)
        }else{
            self.placeState = .empty(emptyMsg)
        }
        if self.isFooterRefreshing{
            self.footerEndRefreshingWithEmpty()
        }
    }
    public func endRefreshingWithError(error:Error){
        if self.isHeaderRefreshing{
            self.headerEndRefreshingWithError(error: error)
        }else{
            self.placeState = .error(error)
        }
        if self.isFooterRefreshing{
            self.footerEndRefreshingWithError(error: error)
        }
    }
    
}

extension RefreshConfig{
    fileprivate func addMJHeader(){
        if self.scrollView?.mj_header != nil {return}
        self.headerView.refreshConfig = self
        self.scrollView?.mj_header = DefaultMJHeaderComponent.init(container: self.headerView)
        self.scrollView?.mj_header?.refreshingBlock = {[weak self] in
            self?.scrollView?.mj_footer = nil
            self?.isHeaderRefreshing = true
            self?.placeState = .refreshing
            self?.headerBlock?()
        }
    }
    
    fileprivate func addMJFooter(){
        if self.scrollView?.mj_footer != nil{return}
        self.footerView.refreshConfig = self
        self.scrollView?.mj_footer = DefaultMJFooterComponent.init(container: self.footerView)
        self.scrollView?.mj_footer?.refreshingBlock = {[weak self] in
            self?.isFooterRefreshing = true
            self?.footerBlock?()
        }
    }
}
