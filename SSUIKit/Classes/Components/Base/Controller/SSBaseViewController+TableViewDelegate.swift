//
//  SSBaseViewController+TableViewDelegate.swift
//  BlocksKit
//
//  Created by 吴頔 on 2019/12/13.
//

import UIKit

/// 列表的代理
public protocol SSTableViewDelegate {
    
    typealias HeightForRowAtIndexPath = (IndexPath) -> CGFloat?
    typealias HeightForHeaderInSection = (Int) -> CGFloat?
    typealias ViewForHeaderInSection = (Int) -> UIView?
    typealias HeightForFooterInSection = (Int) -> CGFloat?
    typealias ViewForFooterInSection = (Int) -> UIView?
    typealias WillDisplayHeaderView = (UIView, Int) -> ()
    typealias WillDisplayFooterView = (UIView, Int) -> ()
    typealias WillDisplayCell = (UITableView, UITableViewCell, IndexPath) -> ()
    
    /// 行高
    var heightForRowAtIndexPath: HeightForRowAtIndexPath? { get set }
    
    /// 分组头部视图的高度
    var heightForHeaderInSection: HeightForHeaderInSection? { get set }
    
    /// 分组头部视图
    var viewForHeaderInSection: ViewForHeaderInSection? { get set }
    
    /// 分组尾部视图高度
    var heightForFooterInSection: HeightForFooterInSection? { get set }
    
    /// 分组尾部视图
    var viewForFooterInSection: ViewForFooterInSection? { get set }
    
    /// 头部视图将要绘制
    var willDisplayHeaderView: WillDisplayHeaderView? { get set }
    
    /// 尾部视图将要绘制
    var willDisplayFooterView: WillDisplayFooterView? { get set }
    
    /// cell将要绘制
    var willDisplayCell: WillDisplayCell? { get set }
}

extension SSBaseViewController {

    internal struct TableViewDelegateAssociatedKeys {
        static var heightForRowAtIndexPath = "ss_baseViewControllerTableViewHeightForRowAtIndexPath"
        static var heightForHeaderInSection = "ss_baseViewControllerTableViewHeightForHeaderInSection"
        static var viewForHeaderInSection = "ss_baseViewControllerTableViewViewForHeaderInSection"
        static var heightForFooterInSection = "ss_baseViewControllerTableViewHeightForFooterInSection"
        static var viewForFooterInSection = "ss_baseViewControllerTableViewViewForFooterInSection"
        static var willDisplayHeaderView = "ss_baseViewControllerTableViewWillDisplayHeaderView"
        static var willDisplayFooterView = "ss_baseViewControllerTableViewWillDisplayFooterView"
        static var willDisplayCell = "ss_baseViewControllerTableViewWillDisplayCell"
    }

    internal func ss_set(_ key: UnsafeRawPointer, newValue: Any) {
        objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    internal func ss_get<T>(_ key: UnsafeRawPointer, type: T.Type) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }

    
}

extension SSBaseViewController: SSTableViewDelegate {
    public var heightForRowAtIndexPath: HeightForRowAtIndexPath? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.heightForRowAtIndexPath, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.heightForRowAtIndexPath, type: HeightForRowAtIndexPath.self) }
    }
    
    public var heightForHeaderInSection: HeightForHeaderInSection? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.heightForHeaderInSection, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.heightForHeaderInSection, type: HeightForHeaderInSection.self) }
    }
    
    public var viewForHeaderInSection: ViewForHeaderInSection? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.viewForHeaderInSection, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.viewForHeaderInSection, type: ViewForHeaderInSection.self) }
    }
    
    public var heightForFooterInSection: HeightForFooterInSection? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.heightForFooterInSection, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.heightForFooterInSection, type: HeightForFooterInSection.self) }
    }
    
    public var viewForFooterInSection: ViewForFooterInSection? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.viewForFooterInSection, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.viewForFooterInSection, type: ViewForFooterInSection.self) }
    }
    
    public var willDisplayHeaderView: WillDisplayHeaderView? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.willDisplayHeaderView, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.willDisplayHeaderView, type: WillDisplayHeaderView.self) }
    }
    
    public var willDisplayFooterView: WillDisplayFooterView? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.willDisplayFooterView, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.willDisplayFooterView, type: WillDisplayFooterView.self) }
    }
    
    public var willDisplayCell: WillDisplayCell? {
        set { ss_set(&type(of: self).TableViewDelegateAssociatedKeys.willDisplayCell, newValue: newValue) }
        get { ss_get(&type(of: self).TableViewDelegateAssociatedKeys.willDisplayCell, type: WillDisplayCell.self) }
    }
}

extension SSBaseViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let heightForRowAtIndexPath = heightForRowAtIndexPath else { return tableView.rowHeight }
        return heightForRowAtIndexPath(indexPath) ?? tableView.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let heightForHeaderInSection = heightForHeaderInSection else { return 0 }
        return heightForHeaderInSection(section) ?? 10
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewForHeaderInSection = viewForHeaderInSection else { return nil }
        return viewForHeaderInSection(section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let heightForFooterInSection = heightForFooterInSection else { return 0 }
        return heightForFooterInSection(section) ?? 1.0 / CGFloat.infinity
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let viewForFooterInSection = viewForFooterInSection else { return nil }
        return viewForFooterInSection(section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let willDisplayHeaderView = willDisplayHeaderView else { return }
        willDisplayHeaderView(view, section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let willDisplayFooterView = willDisplayFooterView else { return }
        willDisplayFooterView(view, section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let willDisplayCell = willDisplayCell else { return }
        willDisplayCell(tableView, cell, indexPath)
    }
}
