//
//  UIScrollView+YKRefresh.swift
//  YKSwiftRefresh
//
//  Created by edward on 2021/12/22.
//

import Foundation
import UIKit
import ESPullToRefresh
import YKSwiftBaseClass

extension UIScrollView
{
    
    /// 添加头部刷新
    /// - Parameters:
    ///   - view: 头部刷新显示的view
    ///   - viewModel: 刷新修改所用viewModel
    ///   - refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshHeader(view:UIView?, viewModel:YKViewModel?, refreshBlock: (()->Void)? = nil) -> Void {
        weak var weakView = view
        weak var weakViewModel = viewModel
        let refresh:(()->Void) = {
            if  let vm = weakViewModel {
                vm.page = 1
            }
            if let block = refreshBlock {
                block()
            }
        }
        
        let header = self.es.addPullToRefresh {
            refresh()
        }
        
        
        if let v = weakView {
            let headerbgView = UIView.init(frame: header.bounds)
            headerbgView.addSubview(v)
            header.addSubview(headerbgView)
        }
    }
    
    /// 添加头部刷新
    /// - Parameters:
    ///   - viewModel: 刷新修改所用viewModel
    ///   - refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshHeader(viewModel:YKViewModel?, refreshBlock:(()->Void)?) -> Void {
        addRefreshHeader(view: nil, viewModel: viewModel, refreshBlock: refreshBlock)
    }
    
    /// 添加头部刷新
    /// - Parameters:
    ///   - view: 头部刷新view
    ///   - refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshHeader(view:UIView?, refreshBlock:(()->Void)?) -> Void {
        addRefreshHeader(view: view, viewModel: nil, refreshBlock: refreshBlock)
    }
    
    /// 添加头部刷新
    /// - Parameter refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshHeader(refreshBlock:(()->Void)?) -> Void {
        addRefreshHeader(view: nil, viewModel: nil, refreshBlock: refreshBlock)
    }
    
    /// 添加底部刷新
    /// - Parameters:
    ///   - view: 底部刷新view
    ///   - viewModel: 刷新修改所用viewModel
    ///   - refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshFooter(view:UIView?, viewModel:YKViewModel?, refreshBlock:(()->Void)?) -> Void {
        let refresh:(()->Void) = {
            if let vm = viewModel {
                vm.page = vm.page + 1
            }
            if let block = refreshBlock {
                block()
            }
        }
        
        let footer = self.es.addInfiniteScrolling {
            refresh()
        }
        
        if let v = view {
            let headerbgView = UIView.init(frame: footer.bounds)
            headerbgView.addSubview(v)
            footer.addSubview(headerbgView)
        }
    }
    
    /// 添加底部刷新
    /// - Parameters:
    ///   - viewModel: 刷新修改所用viewModel
    ///   - refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshFooter(viewModel:YKViewModel?, refreshBlock:(()->Void)?) -> Void {
        addRefreshFooter(view: nil, viewModel: viewModel, refreshBlock: refreshBlock)
    }
    
    /// 添加底部刷新
    /// - Parameters:
    ///   - view: 底部刷新view
    ///   - refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshFooter(view:UIView?, refreshBlock:(()->Void)?) -> Void {
        addRefreshFooter(view: view, viewModel: nil, refreshBlock: refreshBlock)
    }
    
    /// 添加底部刷新
    /// - Parameter refreshBlock: 刷新回调
    /// - Returns: 无
    public func addRefreshFooter(refreshBlock:(()->Void)?) -> Void {
        addRefreshFooter(view: nil, viewModel: nil, refreshBlock: refreshBlock)
    }
    
    
    /// 头部结束刷新
    /// - Returns: 无
    public func headerEndRefresh() -> Void {
        es.stopPullToRefresh()
    }
    
    /// <#Description#>
    /// - Parameter noMorData: 是否没有
    /// - Returns: <#description#>
    public func footerEndRefresh(noMorData:Bool) -> Void {
        if noMorData {
            es.noticeNoMoreData()
        } else {
            es.stopLoadingMore()
        }
    }
    
    public func headerBeginRefresh() -> Void {
        es.startPullToRefresh()
    }
}
