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
    case nerver
    case successOnce //刷新成功一次后
}

public class RefreshConfig{
    
    weak var scrollView : UIScrollView?
    
    public var placeViewEnable = true //是否使用占位 空白图
    public var placeView : PlaceComponent? = Refresher.default.placeView
    
    public var headerView : RefreshComponent  = Refresher.default.headerView
    public var footerView : RefreshComponent = Refresher.default.footerView
    
    public var headerBlock : (()->Void)?
    public var footerBlock : (()->Void)?
    
    
    public var headerTime = AddRefreshComponentTime.successOnce
    public var footerTime = AddRefreshComponentTime.successOnce
    
    
    var placeState : PlaceState = .normal{
        didSet{
            print("placeState:\(placeState)")
            self.placeView?.placeState = placeState
            self.scrollView?.ept.reloadData()
        }
    }
}

extension RefreshConfig : EmptyDataSource{
    public func customViewForEmpty(in view: UIView) -> UIView? {
        if !placeViewEnable{return nil}
        return self.placeView
    }
}


extension RefreshConfig{
    
    //头部开始刷新
    public func headerBeginRefreshing(){
        //去除footer
        self.scrollView?.mj_footer = nil
        
        if self.placeViewEnable,self.scrollView?.ept.dataSource == nil{
            self.scrollView?.ept.dataSource = self
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
            self.placeState = .refreshing
            headerBlock()
            return
        }
        //有header的时候 在 刷新block里面添加了设置placeState，所以这里不需要设置了
        header.beginRefreshing()
    }
    
    public func headerEndRefreshingWithSuccess(){
        self.placeState = .normal
        (self.scrollView?.mj_header as? DefaultMJHeaderComponent)?.endRefreshingWithSuccess()
        if self.headerTime == .successOnce{
            self.addMJHeader()
        }
        if self.footerTime == .successOnce{
            self.addMJFooter()
        }
    }
    
    public func headerEndRefreshingWithEmpty(){
        self.placeState = .empty
        (self.scrollView?.mj_header as? DefaultMJHeaderComponent)?.endRefreshingWithEmpty()
    }
    public func headerEndRefreshingWithError(error:Error){
        self.placeState = .error(error)
        (self.scrollView?.mj_header as? DefaultMJHeaderComponent)?.endRefreshingWithError(error: error)
    }
    
    
    public func footerBeginRefreshing(){
        guard let footerBlock = self.footerBlock else{return}
        guard let footer = self.scrollView?.mj_footer else{
            footerBlock()
            return
        }
        footer.beginRefreshing()
    }
    public func footerEndRefreshingWithSuccess(){
        (self.scrollView?.mj_footer as? DefaultMJFooterComponent)?.endRefreshingWithSuccess()
    }
    
    public func footerEndRefreshingWithEmpty(){
        (self.scrollView?.mj_footer as? DefaultMJFooterComponent)?.endRefreshingWithEmpty()
    }
    public func footerEndRefreshingWithError(error:Error){
        (self.scrollView?.mj_footer as? DefaultMJFooterComponent)?.endRefreshingWithError(error: error)
    }
    
    
    public func endRefreshingWithSuccess(){
        if let h = self.scrollView?.mj_header.isRefreshing,h{
            self.headerEndRefreshingWithSuccess()
        }
        if let r = self.scrollView?.mj_footer.isRefreshing,r{
            self.footerEndRefreshingWithSuccess()
        }
    }
    public func endRefreshingWithEmpty(){
        if let h = self.scrollView?.mj_header.isRefreshing,h{
            self.headerEndRefreshingWithEmpty()
        }
        if let r = self.scrollView?.mj_footer.isRefreshing,r{
            self.footerEndRefreshingWithEmpty()
        }
    }
    public func endRefreshingWithError(error:Error){
        if let h = self.scrollView?.mj_header.isRefreshing,h{
            self.headerEndRefreshingWithError(error: error)
        }
        if let r = self.scrollView?.mj_footer.isRefreshing,r{
            self.footerEndRefreshingWithError(error: error)
        }
    }
    
}

extension RefreshConfig{
    fileprivate func addMJHeader(){
        if self.scrollView?.mj_header != nil {return}
        self.scrollView?.mj_header = DefaultMJHeaderComponent.init(container: self.headerView)
        self.scrollView?.mj_header.refreshingBlock = {[weak self] in
            self?.placeState = .refreshing
            self?.headerBlock?()
        }
    }
    
    fileprivate func addMJFooter(){
        if self.scrollView?.mj_footer != nil{return}
        self.scrollView?.mj_footer = DefaultMJFooterComponent.init(container: self.footerView)
        self.scrollView?.mj_footer.refreshingBlock = {[weak self] in
            self?.footerBlock?()
        }
    }
}
