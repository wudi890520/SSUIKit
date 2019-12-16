//
//  TableView+Rx.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/16.
//

import UIKit
import RxCocoa
import RxSwift
import DZNEmptyDataSet

public enum SSScrollDirection {
    /// 没滑动
    case none
    /// 向上滑动，显示更多
    case up
    /// 向下滑动，显示顶部
    case down
}

public extension Reactive where Base: UITableView {
    public var deselected: Binder<IndexPath> {
        return Binder(base) { tableView, indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    public var didSelectedAt: Binder<Int> {
        return Binder(base) { tableView, row in
            tableView.selectRow(
                at: IndexPath(row: row, section: 0),
                animated: false,
                scrollPosition: .none
            )
        }
    }
    
    public var didSelectedAtFirst: Binder<Void> {
        return Binder(base) { tableView, row in
            
            if tableView.numberOfRows(inSection: 0) == 0 {
                return
            }
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(
                at: indexPath,
                animated: false,
                scrollPosition: .none
            )
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }
    
    public var scrollToBottom: Binder<Bool> {
        return Binder(base) { tableView, animated in
            tableView.ss_scrollToBottom(animated)
        }
    }
}

public extension Reactive where Base: UITableView {
    public func ss_items<DataSource: RxTableViewDataSourceType & UITableViewDataSource, O: ObservableType>(_ dataSource: DataSource) -> (_ source: O) -> Disposable
        where DataSource.Element == O.Element {
        return base.rx.items(dataSource: dataSource)
    }
    
    public func scrollDirection(_ isNeedThinkContentSize: Bool = false, animated: Bool = true) -> Driver<SSScrollDirection> {
        let scrollView = base
        
        let dueTime = animated.ss_ternary(DispatchTimeInterval.Duration.ss_animate, DispatchTimeInterval.Duration.ss_min)
        if isNeedThinkContentSize {
            if scrollView.numberOfSections == 0 {
                return Driver.just(.none)
            }
            else if scrollView.numberOfRows(inSection: 0) == 0 {
                return Driver.just(.none)
            }
            else if scrollView.contentSize.height < scrollView.qmui_height {
                return Driver.just(.none)
            }
        }
        
        return base.rx.didScroll
            .asDriver()
            .map { (_) -> SSScrollDirection in
                let point = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
                if point.y > 0 {
                    return .down
                }else{
                    return .up
                }
            }
            .distinctUntilChanged()
            .throttle(dueTime, latest: false)
    }
}

public extension Reactive where Base: UITableView {

    public var isLoading: Binder<Bool?> {
        return Binder(base) { tableView, isLoading in
            guard let isLoading = isLoading else { return }
            guard let loadingView = tableView.ss_loadingView else { return }
            
            if let tableHeaderView = tableView.tableHeaderView {
                loadingView.top = tableHeaderView.bottom
            }
            
            if isLoading {
                if tableView.numberOfRows(inSection: 0) != 0 {
                    return
                }
                tableView.addSubview(loadingView)
            }else{
                UIView.animate(withDuration: TimeInterval.Duration.ss_animate, animations: {
                    loadingView.alpha = 0
                }, completion: { (_) in
                    loadingView.removeFromSuperview()
                    tableView.ss_loadingView = nil
                })
            }
        }
    }
    
}

public extension UITableView {
    public var ss_itemSelected: Driver<IndexPath> {
        return self.rx.itemSelected.asDriver()
    }
    
    public func ss_modelSelected<T>(_ type: T.Type) -> Driver<T> {
        return self.rx.modelSelected(type).asDriver()
    }
}



