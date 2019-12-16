//
//  MJRefresh+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

public extension Reactive where Base: UITableView {
    
    public var request: Driver<Int> {
        return Driver.merge(headerRefreshing, footerRefreshing)
    }
    
    /// 正在刷新
    public var headerRefreshing: Driver<Int> {
        return base.mj_header.rx.refreshing.asDriver()
            .do(onNext: { [weak control = self.base] _ in control?.ss_page = 1 })
            .map{ 1 }
    }
    
    /// 正在加载更多
    public var footerRefreshing: Driver<Int> {
        return base.mj_footer.rx.refreshing.asDriver()
            .do(onNext: { [weak control = self.base] _ in control?.ss_page = (control?.ss_page ?? 1) + 1 })
            .map{ [weak control = self.base] _ in control?.ss_page }
            .filterNil()
    }
    
    /// 停止刷新
    public var endRefreshing: Binder<Void> {
        return Binder(base) { tableView, _ in
            tableView.endRefreshing()
        }
    }
    
    /// 停止刷新（没有更多数据）
    public var noMoreData: Binder<Bool> {
        return Binder(base) { tableView, isNoMoreData in
            if let footer = tableView.mj_footer {
                footer.isHidden = isNoMoreData
            }
        }
    }
    
    /// 开始刷新
    public var beginRefreshing: Binder<Void> {
        return Binder(base) { tableView, _ in
            if let header = tableView.mj_header {
                header.beginRefreshing()
            }
        }
    }
    
    public var reloadData: Binder<Void> {
        return Binder(base) { tableView, _ in
            tableView.reloadData()
        }
    }
}

extension Reactive where Base: MJRefreshComponent {
    /// 下拉刷新
    public var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    /// 停止刷新
    public var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                if let header = refresh as? MJRefreshGifHeader {
                    header.willEndRefreshing()
                    header.reloadIdleImages()
                }
                refresh.endRefreshing()
            }
        }
    }
}

