//
//  TableView.swift
//  SSUIKit
//
//  Created by 吴頔 on 2019/11/30.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MJRefresh
import DZNEmptyDataSet
import RxCocoa
import RxSwift

public typealias TableView = UITableView

public protocol SSUITableViewCompatible {}
extension UITableView: SSUITableViewCompatible {}

/// 列表加载中的视图类型
///
/// - cell: 以cell为单位
/// - whole: 平铺整个列表
public enum SSTableLoadingViewType {
    case cell
    case whole
}

public extension UITableView {
  
    internal struct AssociatedKeys {
        static var emptyDataImage = "ss_emptyDataImage"
        static var emptyDataTitle = "ss_emptyDataTitle"
        static var emptyDataSubtitle = "ss_emptyDataSubtitle"
        static var emptyDataButtonTitle = "ss_emptyDataButtonTitle"
        static var emptyDataButtondDidTap = "ss_emptyDataButtondDidTap"
        static var loadingView = "ss_loadingView"
        static var page = "ss_dataSource_currentPage"
        static var emptyDataButton = "ss_emptyDataButton"
    }
    
    internal func ss_set(_ key: UnsafeRawPointer, newValue: Any) {
        objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    internal func ss_get<T>(_ key: UnsafeRawPointer, type: T.Type) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    
    /// 空列表图片
    var ss_emptyDataImage: UIImage? {
        set { ss_set(&type(of: self).AssociatedKeys.emptyDataImage, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.emptyDataImage, type: UIImage.self) }
    }
    
    /// 空列表标题
    var ss_emptyDataTitle: String? {
        set { ss_set(&type(of: self).AssociatedKeys.emptyDataTitle, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.emptyDataTitle, type: String.self) }
    }
    
    /// 空列表副标题
    var ss_emptyDataSubtitle: String? {
        set { ss_set(&type(of: self).AssociatedKeys.emptyDataSubtitle, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.emptyDataSubtitle, type: String.self) }
    }
    
    /// 空列表按钮标题
    var ss_emptyDataButtonTitle: String? {
        set { ss_set(&type(of: self).AssociatedKeys.emptyDataButtonTitle, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.emptyDataButtonTitle, type: String.self) }
    }
   
    /// 按钮点击了
    public var ss_emptyDataButtonDidTap: PublishSubject<Void>? {
        set { ss_set(&type(of: self).AssociatedKeys.emptyDataButtondDidTap, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.emptyDataButtondDidTap, type: PublishSubject<Void>.self) }
    }
    
    /// 当前页数
    var ss_page: Int {
        set { ss_set(&type(of: self).AssociatedKeys.page, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.page, type: Int.self) ?? 1 }
    }
    
    /// 加载中视图
    var ss_loadingView: UIView? {
        set { ss_set(&type(of: self).AssociatedKeys.loadingView, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.loadingView, type: UIView.self) }
    }
    
    /// 空列表时的按钮
    var ss_emptyDataButton: UIButton? {
        set { ss_set(&type(of: self).AssociatedKeys.emptyDataButton, newValue: newValue) }
        get { ss_get(&type(of: self).AssociatedKeys.emptyDataButton, type: UIButton.self) }
    }
}

public extension SSUITableViewCompatible where Self: UITableView {

    /// 静态方法初始化 UITableView.Style.plain
    ///
    /// - Returns: UITableView
    static func ss_plain() -> UITableView {
        return UITableView(frame: .zero, style: .plain)
            .ss_backgroundColor(.ss_background)
            .ss_hideSeparator()
    }

    /// 静态方法初始化 UITableView.Style.grouped
    ///
    /// - Returns: UITableView
    static func ss_grouped() -> UITableView {
        return UITableView(frame: .zero, style: .grouped)
            .ss_backgroundColor(.ss_background)
            .ss_addEmptyHeader()
    }

}

public extension SSUITableViewCompatible where Self: UITableView {

    /// 向列表注册Cell类型
    ///
    /// - Parameter nibResource: Resource
    /// - Returns: UITableView
    @discardableResult
    func ss_register(_ className: AnyClass) -> Self {
        let nibName = "\(className.description())".components(separatedBy: ".")
        if let path = Bundle.init(for: className).path(forResource: nibName.first, ofType: "bundle") {
            let bundle = Bundle.init(path: path)
            let nib = UINib.init(nibName: nibName.last ?? "", bundle: bundle)
            register(nib, forCellReuseIdentifier: nibName.last ?? "")
            return self
        }else{
            let bundle = Bundle.init(for: className)
            let nib = UINib.init(nibName: nibName.last ?? "", bundle: bundle)
            register(nib, forCellReuseIdentifier: nibName.last ?? "")
            return self
        }
    }

    /// 隐藏多余的分隔线
    ///
    /// - Returns: UITableView
    @discardableResult
    func ss_hideSeparator() -> Self {
        tableFooterView = UIView()
        return self
    }

    /// 隐藏所有的分隔线
    ///
    /// - Returns: UITableView
    @discardableResult
    func ss_separatorStyleNone() -> Self {
        separatorStyle = .none
        separatorColor = .clear
        return self
    }

    /// 设置Cell高度
    ///
    /// - Parameter rowHeight: CGFloat
    /// - Returns: UITableView
    @discardableResult
    func ss_rowHeight(_ rowHeight: CGFloat) -> Self {
        self.estimatedRowHeight = rowHeight
        self.rowHeight = rowHeight
        return self
    }

    /// 自适应Cell高度
    ///
    /// - Parameter rowHeight: CGFloat
    /// - Returns: UITableView
    @discardableResult
    func ss_estimatedRowHeight(_ rowHeight: CGFloat = CGFloat.screenHeight) -> Self {
        self.estimatedRowHeight = rowHeight
        self.rowHeight = UITableView.automaticDimension
        return self
    }

    /// 不启用自动计算
    ///
    /// - Returns: UITableView
    @discardableResult
    func ss_disableEstimated() -> Self {
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
        return self
    }

    /// 添加tableHeaderView
    ///
    /// - Returns: UITableView
    @discardableResult
    func ss_tableHeaderView(_ tableHeaderView: UIView?) -> Self {
        self.tableHeaderView = tableHeaderView
        return self
    }

    /// 添加tableFooterView
    ///
    /// - Returns: UITableView
    @discardableResult
    func ss_tableFooterView(_ tableFooterView: UIView?) -> Self {
        self.tableFooterView = tableFooterView
        return self
    }

    /// 添加tableHeaderView
    ///
    /// - Returns: UITableView
    @discardableResult
    func ss_addEmptyHeader(_ headerViewHeight: CGFloat = 1 / UIScreen.main.scale) -> Self {
        tableHeaderView = UIView()
            .ss_frame(x: 0, y: 0, width: CGFloat.screenWidth, height: headerViewHeight)
        return self
    }

    /// 不要越界
    ///
    /// - Returns: UITableView
    @discardableResult
    func ss_clipsToBounds() -> Self {
        clipsToBounds = true
        return self
    }

    /// 分组下标颜色
    ///
    /// - Parameter color: UITableView
    @discardableResult
    func ss_sectionIndexColor(_ color: UIColor?) -> Self {
        sectionIndexColor = color
        return self
    }

    /// 注册加载列表时的 loading View
    ///
    /// - Parameters:
    ///   - view: UIView
    ///   - loadingType: SSTableLoadingViewType
    /// - Returns: UITableView
    @discardableResult
    func ss_registerLoadingView<T: UIView>(_ classType: T.Type, space: CGFloat = 10, loadingType: SSTableLoadingViewType = .cell) -> Self {
        if loadingType == .cell {

            let loadingView = UIView()
                .ss_frame(x: 0, y: 0, width: .screenWidth, height: .screenHeight)
                .ss_isEnable(false)

            for i in 0 ..< 20 {
                let subview = T.init()
                subview.centerX = .screenWidth / 2
                subview.top = space + (subview.height + space) * i.ss_cgFloat
                loadingView.addSubview(subview)
                if subview.bottom > .screenHeight {
                    break
                }
            }
            self.ss_loadingView = loadingView
        }else{
            self.ss_loadingView = T.init()
        }
        return self
    }

    /// 添加刷新
    ///
    /// - Parameter color: UITableView
    @discardableResult
    func ss_addRefreshHeader() -> Self {
        addRefreshHeader()
        return self
    }

    /// 添加加载更多
    ///
    /// - Parameter color: UITableView
    @discardableResult
    func ss_addRefreshFooter() -> Self {
        addRefreshFooter()
        return self
    }
    
    /// 添加空列表按钮
    ///
    /// - Parameter color: UITableView
    @discardableResult
    func ss_addEmptyDataButton() -> Self {
        self.ss_emptyDataButton = UIButton()
        return self
    }
}

public extension SSUITableViewCompatible where Self: UITableView {
    /// 添加刷新
    func addRefreshHeader() {
        let header = MJRefreshGifHeader(refreshingBlock: nil)

        header?.setIdleImages()
        header?.setRefreshingImages()
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        mj_header = header
    }

    /// 添加加载更多
    func addRefreshFooter() {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: nil)
        footer?.activityIndicatorViewStyle = .gray
        footer?.setTitle("正在加载...", for: .refreshing)
        footer?.setTitle("", for: .noMoreData)
        footer?.setTitle("", for: .idle)
        footer?.stateLabel.font = UIFont.systemFont(ofSize: 15)
        footer?.labelLeftInset = 20
        footer?.isHidden = true
        mj_footer = footer
    }

    func endRefreshing() {
        if let header = self.mj_header as? MJRefreshGifHeader {
            header.willEndRefreshing()
            header.reloadIdleImages()
            header.endRefreshing()
        }

        if let footer = self.mj_footer{
            footer.endRefreshing()
        }
    }
}

public extension SSUITableViewCompatible where Self: UITableView {
    func ss_scrollToBottom(_ animated: Bool) {
        let rows = numberOfRows(inSection: 0)
        if rows > 0 {
            let indexPath = IndexPath(row: rows-1, section: 0)
            scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}

extension UITableView: DZNEmptyDataSetSource {
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let title = ss_emptyDataTitle else { return nil }
        return title
            .ss_attribute
            .ss_color(color: .gray)
            .ss_font(font: UIFont.lightTitle.bold)
            .ss_alignment(alignment: .center)
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        guard let image = ss_emptyDataImage else { return nil }
        return image
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        guard let title = ss_emptyDataSubtitle else { return nil }
        return title
            .ss_attribute
            .ss_color(color: .lightGray)
            .ss_font(font: UIFont.lightDetail)
            .ss_alignment(alignment: .center)
    }
  
    public func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        guard let title = ss_emptyDataButtonTitle else { return nil }

        let attributeImage = title
            .ss_attribute
            .ss_color(color: .white)
            .ss_font(font: .largeDetail)
            .ss_alignment(alignment: .center)
            .ss_image


        guard let image = attributeImage else { return nil }
        guard let backgroundImage = UIImage.qmui_image(with: .ss_main, size: CGSize(width: image.size.width+60, height: 44), cornerRadius: 22) else { return nil }
        let point = CGPoint(
            x: (backgroundImage.size.width - image.size.width) / 2,
            y: (backgroundImage.size.height - image.size.height) / 2
        )
        return backgroundImage
            .qmui_imageWithImage(above: image, at: point)?
            .ss_extension(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension UITableView: DZNEmptyDataSetDelegate {
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        ss_emptyDataButton?.sendActions(for: .touchUpInside)
    }
    
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        let headerViewHeight: CGFloat = self.tableHeaderView?.height ?? 0
        return headerViewHeight
    }
}
