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

    var shouldDismiss: ((Void) -> Void)?

    private let contentView = UIView()
        .ss_backgroundColor(SSAlertConfiguration.shared.displayView.backgroundColor)
        .ss_layerCornerRadius(SSAlertConfiguration.shared.displayView.cornerRadius)
    
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
                addTableViewElement(dataSource: dataSource, rowHeight: rowHeight)
                
            case let .button(title, titleColor, backgroundColor, type, callback):
                let button = addButtonElement(title: title, titleColor: titleColor, backgroundColor: backgroundColor, type: type)

                button.rx.tap
                    .subscribe(onNext: {[weak self] (_) in
                        callback?(())
                        self?.shouldDismiss?(())
                    })
                    .disposed(by: dispose)
                
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
    
    private func addTextFieldElement(placeholder: String, keyboardType: SSKeyboardType, insets: UIEdgeInsets, leftTitle: NSMutableAttributedString?, rightTitle: NSMutableAttributedString?) -> QMUITextField {
        let textField = QMUITextField()
        
        textField
            .ss_frame(x: insets.left, y: contentView.height, width: width - insets.left - insets.right, height: 50)
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
    
    private func addTableViewElement(dataSource: [SSAlertDisplayTableViewItemData], rowHeight: CGFloat) {
        
    }
    
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
            
        default:
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
        }
    }
}

extension SSAlertCustomView {
    
}
