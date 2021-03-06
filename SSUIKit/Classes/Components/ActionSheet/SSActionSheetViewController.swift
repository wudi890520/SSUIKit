//
//  SSActionSheet.swift
//  SSUIKit_Example
//
//  Created by 吴頔 on 2019/12/5.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public typealias SSActionSheet = SSActionSheetViewController

public class SSActionSheetViewController: UIViewController {

    private let subViews = SSActionSheetViewContainer()
    
    private let datas = SSActionSheetDataContainer()
    
    private let layout = SSActionSheetLayoutManager()
    
    private let viewModel = SSActionSheetViewModel()
    
    private var currentSelectedItemData: SSActionSheetButtonItemData?
    
    private let dispose = DisposeBag()
  
    internal init(_ title: String?) {
        super.init(nibName: nil, bundle: nil)
        subViews.titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            subViews.tableView.delegate = self
            subViews.tableView.dataSource = self
            subViews.tableView.reloadData()
        }
        
        ss_layoutSubviews()
        ss_bindDataSource()
    }
    
    deinit {
        print("SSActionSheetViewController deinit")
    }
}

extension SSActionSheetViewController {
    private func ss_layoutSubviews() {
        layout.make(children: subViews, in: view)
    }
}

extension SSActionSheetViewController {
    private func ss_bindDataSource() {
        subViews.cancelButton.rx.tap
            .subscribe(onNext: {[weak self] (_) in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: dispose)
    }
}

extension SSActionSheetViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSActionSheetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSActionSheetTableViewCell", for: indexPath) as! SSActionSheetTableViewCell
        let data = datas.dataSource[indexPath.row]
        if let attribute = data.attribute {
            cell.titleLabel.attributedText = attribute
        }else{
            cell.titleLabel.attributedText = nil
            cell.titleLabel.text = data.title
            cell.titleLabel.textColor = data.titleColor
        }
        cell.line.isHidden = indexPath.row == 0
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true) { [weak self] in
            self?.datas.setSelected(indexPath)
        }
    }
}


extension SSActionSheetViewController {
    static private func height(_ itemsCount: Int, title: String? = nil) -> CGFloat {
        var titleHeight: CGFloat = 0
        if let title = title {
            titleHeight = title.ss_nsString.height(for: SSActionSheetConfiguration.shared.titleLabelFont, width: CGFloat.screenWidth-40) + 40
        }
        
        let tableViewHeight = itemsCount.ss_cgFloat * SSActionSheetConfiguration.shared.rowHeight
        return titleHeight + tableViewHeight + 8 + SSActionSheetConfiguration.shared.rowHeight
    }
}

public extension SSActionSheet {
 
    /// 弹出action sheet
    /// - Parameter title: 标题
    /// - Parameter cancelButtonTitle: 取消按钮标题
    /// - Parameter buttonItems: 按钮数组
    /// - Parameter guideView: 引导图
    static func show<T>(
        _ title: String? = nil,
        cancelButtonTitle: SSActionSheetButtonItem<T> = .cancel(extra: nil),
        buttonItems: [SSActionSheetButtonItem<T>],
        guideView: UIView? = nil) -> Driver<T?> {
        let sheet = SSActionSheet(title)
        sheet.datas.dataSource = buttonItems.map{ $0.data }
        let height = SSActionSheet.height(buttonItems.count, title: title)
        UIApplication.visiableController?.presentAsStork(sheet, height: height, swipeToDismissEnabled: false, tapAroundToDismissEnabled: true, complection: nil)

        return sheet.datas.selected.map{ buttonItems[$0].extra }
    }
    
    
}

public extension SSActionSheet {
    /// 弹出相机、相册
    /// - Parameter isNeedCamera: 是否需要拍照
    /// - Parameter albumMaxCount: 从相册选择的最大图片数量，默认为1，代表不需要从相册选择
    ///   - 如果 albumMaxCount传0，代表不需要从相册选择
    static func photo(isNeedCamera: Bool = true, albumMaxCount: Int = 1) -> Driver<[UIImage]> {

        var items: [SSActionSheetButtonItem<Any>] = []

        if isNeedCamera {
            items.append(.camera)
        }

        if albumMaxCount > 0 {
            items.append(.album(maxPhotoCount: albumMaxCount))
        }

        let sheet = SSActionSheet(nil)
        sheet.datas.dataSource = items.map{ $0.data }
        let height = SSActionSheet.height(items.count, title: nil)
        UIApplication.visiableController?.presentAsStork(sheet, height: height, swipeToDismissEnabled: false, tapAroundToDismissEnabled: true, complection: nil)

        return sheet.datas.selected
            .map{ items[$0] }
            .flatMapLatest{ SSPhotoManager.show($0) }
            .filterNil()
    }
}
