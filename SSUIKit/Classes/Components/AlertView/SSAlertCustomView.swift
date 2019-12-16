//
//  SSAlertCustomView.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/6.
//

import UIKit
import QMUIKit
import RxCocoa
import RxSwift
import RxKeyboard

class SSAlertCustomView: UIView {
    
    /// 回调，alert控制器消息
    var shouldDismiss: ((Void) -> Void)?
    
    /// 内容视图
    private let contentView = UIView()
        .ss_backgroundColor(SSAlertConfiguration.shared.displayView.backgroundColor)
        .ss_layerCornerRadius(SSAlertConfiguration.shared.displayView.cornerRadius)
    
    /// 列表数据源
    private var tableViewDataSource: [SSAlertDisplayTableViewItemData] = []
    
    /// 列表点击cell事件回调
    private var tableViewSelected: ((Any?) -> Void)?
    
    /// 信号生命周期
    private let dispose = DisposeBag()
    
    init(elements: [SSAlertDisplayElement]) {
        super.init(frame: CGRect(x: 0, y: 0, width: SSAlertConfiguration.shared.displayView.width, height: SSAlertConfiguration.shared.displayView.maxHeight))
        addSubview(contentView)
        contentView.width = width
        addElements(elements)
        contentView.height = contentView.height+20
        contentView.centerY = height / 2
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SSAlertCustomView {
    
    /// 添加视图元素
    /// - Parameter elements: SSAlertDisplayElement数组
    private func addElements(_ elements: [SSAlertDisplayElement]) {
        var contentHeight: CGFloat = 0
        
        for element in elements {
            switch element {
                
            case let .label(content, insets):
                addLabelElement(content: content, insets: insets)
                
            case let .textField(placeholder, keyboardType, insets, leftTitle, rightTitle, callback):
                let textField = addTextFieldElement(placeholder: placeholder, keyboardType: keyboardType, insets: insets, leftTitle: leftTitle, rightTitle: rightTitle)
                
                textField.rx.text.orEmpty
                    .distinctUntilChanged()
                    .subscribe(onNext: { (text) in
                        callback?(text)
                    })
                    .disposed(by: dispose)
                
                textField.becomeFirstResponder()
                
            case let .tableView(dataSource, rowHeight, callback):
                let tableView = addTableViewElement(dataSource: dataSource, rowHeight: rowHeight)
                self.tableViewSelected = callback
                
            case let .image(source, extra, didTap):
                addImageViewElement(source: source, extra: extra, didTap: didTap)
                
            case let .button(title, titleColor, backgroundColor, type, callback):
                let button = addButtonElement(title: title, titleColor: titleColor, backgroundColor: backgroundColor, type: type)

                button.rx.tap
                    .subscribe(onNext: {[weak self] (_) in
                        callback?(())
                        self?.shouldDismiss?(())
                    })
                    .disposed(by: dispose)
                
            case let .custom(view):
                contentView.addSubview(view)
                contentView.height = view.bottom
                contentView.centerY = SSAlertConfiguration.shared.displayView.maxHeight/2
                contentView.backgroundColor = .clear
            }
        }
    }
}

extension SSAlertCustomView {
    private func bindAction() {
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .subscribe(onNext: {[weak self] (keyboardHeight) in
                let centerY = (SSAlertConfiguration.shared.displayView.maxHeight - keyboardHeight) / 2
                self?.contentView.centerY = centerY
            })
            .disposed(by: dispose)
    }
}

extension SSAlertCustomView {
    
    /// 添加一个label
    /// - Parameter content: label的内容
    /// - Parameter insets: 上下左右的间距
    private func addLabelElement(content: NSMutableAttributedString, insets: UIEdgeInsets) {
        let label = QMUILabel()
        label.numberOfLines = 0
        label.top = contentView.height
        label.width = width - insets.left - insets.right
        let contentSize = content.ss_size(label.width)
        label.left = insets.left
        label.top = contentView.height + insets.top
        label.height = contentSize.height
        label.attributedText = content
        contentView.addSubview(label)
        contentView.height = label.bottom + insets.bottom
    }
    
    /// 添加一个输入框
    /// - Parameter placeholder: 输入框提示文案
    /// - Parameter keyboardType: 键盘类型
    /// - Parameter insets: 上下左右的间距
    /// - Parameter leftTitle: 左标题
    /// - Parameter rightTitle: 右标题
    private func addTextFieldElement(placeholder: String, keyboardType: SSKeyboardType, insets: UIEdgeInsets, leftTitle: NSMutableAttributedString?, rightTitle: NSMutableAttributedString?) -> QMUITextField {
        let textField = QMUITextField()
        
        textField
            .ss_frame(x: insets.left, y: contentView.height+insets.top, width: width - insets.left - insets.right, height: 50)
            .ss_placeholder(placeholder)
            .ss_font(.largeTitle)
            .ss_keyboardType(keyboardType)
            .ss_textAlignment(.center)
            .ss_layerCornerRadius(textField.height/2)
            .ss_layerBorder(color: .ss_line, width: .line)
       
        contentView.addSubview(textField)
        contentView.height = textField.bottom + insets.bottom
        
        if let leftTitle = leftTitle {
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: textField.height))
            let label = UILabel().ss_attribute(leftTitle)
            label.sizeToFit()
            leftView.width = label.width + 50
            label.centerX = leftView.width/2
            label.centerY = leftView.height/2
            leftView.addSubview(label)
            textField.ss_leftView(leftView)
            
            let rightView = UIView(frame: leftView.bounds)
            textField.ss_rightView(rightView)
        }
        
        if let rightTitle = rightTitle {
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: textField.height))
            let label = UILabel().ss_attribute(rightTitle)
            label.sizeToFit()
            rightView.width = label.width + 50
            label.centerX = rightView.width/2
            label.centerY = rightView.height/2
            rightView.addSubview(label)
            textField.ss_rightView(rightView)
        }
        
        return textField
    }
    
    /// 添加一个列表
    /// - Parameter dataSource: 列表数据源
    /// - Parameter rowHeight: 列表行高
    private func addTableViewElement(dataSource: [SSAlertDisplayTableViewItemData], rowHeight: CGFloat) -> UITableView {
        let tableViewHeight = dataSource.count.ss_cgFloat * rowHeight
        let tableView = UITableView.ss_plain()
            .ss_rowHeight(rowHeight)
            .ss_register(SSAlertCustomTableViewCell.self)
            .ss_frame(x: 0, y: contentView.height, width: width, height: tableViewHeight)
        tableViewDataSource = dataSource
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        contentView.height = tableView.bottom + 20
        return tableView
    }
    
    /// 添加按钮元素
    /// - Parameter title: 按钮标题
    /// - Parameter titleColor: 按钮标题颜色
    /// - Parameter backgroundColor: 按钮背景颜色
    /// - Parameter type: 按钮类型
    private func addButtonElement(title: String, titleColor: UIColor?, backgroundColor: UIColor?, type: SSAlertDisplayElementButtonType) -> QMUIButton {
        switch type {
        case .cancel:
            let button = QMUIButton()
            button.ss_backgroundImage(backgroundColor)
            button.ss_title(title)
            button.ss_font(UIFont.with(17).bold)
            button.ss_titleColor(.ss_main)
            button.ss_layerCornerRadius(8)
            button.top = contentView.height
            button.left = 20
            button.height = 44
            button.width = (width - 50)/2
            contentView.addSubview(button)
            contentView.height = button.bottom
            return button
            
        case .confirm:
            let button = QMUIButton()
            button.ss_backgroundImage(backgroundColor)
            button.ss_title(title)
            button.ss_font(UIFont.with(17).bold)
            button.ss_titleColor(.white)
            button.ss_layerCornerRadius(8)
            button.height = 44
            button.width = (width - 50)/2
            button.right = width - 20
            button.bottom = contentView.height
            contentView.addSubview(button)
            return button
        
        case .justOnly:
            let button = QMUIButton()
            button.ss_backgroundImage(backgroundColor)
            button.ss_title(title)
            button.ss_font(UIFont.with(17).bold)
            button.ss_titleColor(.ss_main)
            button.ss_layerCornerRadius(8)
            button.top = contentView.height
            button.left = 20
            button.height = 44
            button.width = width - 40
            contentView.addSubview(button)
            contentView.height = button.bottom
            return button
            
        case .close:
            let button = QMUIButton()
            button.ss_image("close".bundleImage?.byTintColor(.white))
            button.size = CGSize(width: 36, height: 36)
            button.ss_layerCornerRadius(button.height/2)
            button.ss_layerBorder(color: .white, width: 1)
            contentView.height = contentView.height+20
            contentView.centerY = height / 2
            button.top = contentView.bottom + 10
            button.centerX = width/2
            self.addSubview(button)
            return button
        }
    }
    
    /// 添加图片
    /// - Parameter source: 图片资源，支持UIImage，String，URL
    /// - Parameter extra: 附加值，不会处理，会在点击图片时原封不动的返回，多用于返回H5的链接
    /// - Parameter didTap: 点击了图片
    private func addImageViewElement(source: Any?, extra: Any?, didTap: ((Any?) -> Void)?) {
        
        let maxWidth = self.width
        let resizeValue = self.size
        contentView.backgroundColor = .clear
        
        if var image = source as? UIImage {
            
            if image.size.width > width {
                if let resizedImage = image.qmui_imageResized(inLimitedSize: self.size) {
                    image = resizedImage
                }
            }
       
            let imageView = UIImageView(image: image)
            imageView.ss_layerCornerRadius(13)
            imageView.top = contentView.height
            imageView.centerX = width / 2
            contentView.addSubview(imageView)
            contentView.height = imageView.bottom
            
            if let didTap = didTap {
                let tap = UITapGestureRecognizer {[weak self] (_) in
                    didTap(extra)
                    self?.shouldDismiss?(())
                }
                imageView.ss_addGesture(tap)
            }
            
        }else if let url = source as? URL {
            
            var imageView = UIImageView()
            
            imageView.kf.setImage(with: url) {[weak self] (result) in
                switch result {
                case let .success(value):
                    var image = value.image
                    if (image.size.width > maxWidth) == true {
                        if let resizedImage = image.qmui_imageResized(inLimitedSize: resizeValue) {
                            image = resizedImage
                        }
                    }
                    imageView.size = image.size
                    imageView.centerX = maxWidth / 2
                    imageView.top = self?.contentView.height ?? 0
                    imageView.ss_layerCornerRadius(13)
                    self?.contentView.addSubview(imageView)
                    self?.contentView.height = imageView.bottom
                    self?.contentView.centerY = resizeValue.height / 2 - 30
                    let closeButton = self?.subviews.filter{ $0.isKind(of: UIButton.self) }.first
                    closeButton?.top = (self?.contentView.bottom ?? 0) + 30
                    
                    if let didTap = didTap {
                        let tap = UITapGestureRecognizer { (_) in
                            didTap(extra)
                            self?.shouldDismiss?(())
                        }
                        imageView.ss_addGesture(tap)
                    }
                    
                case .failure(_):
                    self?.shouldDismiss?(())
                }
            }
            
        }else if let string = source as? String, let url = URL(string: string) {
            var imageView = UIImageView()
            
            imageView.kf.setImage(with: url) {[weak self] (result) in
                switch result {
                case let .success(value):
                    var image = value.image
                    if (image.size.width > maxWidth) == true {
                        if let resizedImage = image.qmui_imageResized(inLimitedSize: resizeValue) {
                            image = resizedImage
                        }
                    }
                    imageView.size = image.size
                    imageView.centerX = maxWidth / 2
                    imageView.top = self?.contentView.height ?? 0
                    imageView.ss_layerCornerRadius(13)
                    self?.contentView.addSubview(imageView)
                    self?.contentView.height = imageView.bottom
                    self?.contentView.centerY = resizeValue.height / 2 - 30
                    let closeButton = self?.subviews.filter{ $0.isKind(of: UIButton.self) }.first
                    closeButton?.top = (self?.contentView.bottom ?? 0) + 30
                    
                    if let didTap = didTap {
                        let tap = UITapGestureRecognizer { (_) in
                            didTap(extra)
                            self?.shouldDismiss?(())
                        }
                        imageView.ss_addGesture(tap)
                    }
                    
                case .failure(_):
                    self?.shouldDismiss?(())
                }
            }
        }
        
    }
}

extension SSAlertCustomView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SSAlertCustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SSAlertCustomTableViewCell", for: indexPath) as! SSAlertCustomTableViewCell
        let data = tableViewDataSource[indexPath.row]
        cell.imageView?.image = data.image
        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = data.subTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableViewDataSource[indexPath.row]
        self.tableViewSelected?(data.extra)
    }
}
