//
//  SSBannerDataSource.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/9.
//

import UIKit
import FSPagerView
import RxCocoa
import RxSwift

public extension Reactive where Base: SSBannerDataSource {
    /// 点击 Banner
    var tap: ControlEvent<SSBannerImageItem> {
        let source: Observable<SSBannerImageItem> = Observable.create { [weak control = self.base] observer in
            if let control = control, let items = control.imageItems {
                control.didSelected = { index in
                    observer.on(.next(items[index]))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
}

public extension Reactive where Base: SSBannerDataSource {
    
    /// banner的数据源
    var dataSource: Binder<Array<SSBannerConvertible?>> {
        return Binder(base) { pagerView, sources in
            
            if let images = sources as? [UIImage] {
                pagerView.imageItems = images.map({ (image) -> SSBannerImageItem in
                    SSBannerImageItem(source: image, page: nil)
                })
                
                pagerView.cellForItemAt = { cell in
                    cell.imageView?.image = images[cell.tag]
                }
                pagerView.numberOfItems = { images.count }
                
            }else if let strings = sources as? [String] {
                pagerView.imageItems = strings.map({ (string) -> SSBannerImageItem in
                    SSBannerImageItem(source: string, page: nil)
                })
                pagerView.cellForItemAt = { cell in
                    let url = URL(string: strings[cell.tag])
                    cell.imageView?.kf.setImage(with: url)
                }
                pagerView.numberOfItems = { strings.count }
                
            }else if let urls = sources as? [URL] {
                pagerView.imageItems = urls.map({ (string) -> SSBannerImageItem in
                    SSBannerImageItem(source: string, page: nil)
                })
                pagerView.cellForItemAt = { cell in
                    cell.imageView?.kf.setImage(with: urls[cell.tag])
                }
                pagerView.numberOfItems = { urls.count }
            }else if let banners = sources as? [SSBannerImageItem] {
                pagerView.imageItems = banners
                pagerView.pagerView?.isInfinite = (banners.count != 1)
                pagerView.cellForItemAt = { cell in
                    let source = banners[cell.tag].source
                    if let image = source as? UIImage {
                        cell.imageView?.image = image
                    }else if let url = source as? URL {
                        cell.imageView?.kf.setImage(with: url)
                    }else if let string = source as? String, let url = URL(string: string) {
                        cell.imageView?.kf.setImage(with: url)
                    }
                }
                pagerView.numberOfItems = { banners.count }
            }else{
                assert(false, "无法识别的数据类型")
            }
            
            pagerView.pagerView?.reloadData()
        }
    }

}

class SSGuidePageCell: FSPagerViewCell {
    
    static let Identifier = "SSGuidePageCell"
    
    override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            imageView?.removeAllSubviews()
        }
        get {
            return super.isHighlighted
        }
    }
}

public class SSBannerDataSource: NSObject {

    public struct Selector {
        static let didSelected = #selector(FSPagerViewDelegate.pagerView(_:didSelectItemAt:))
        static let numberOfItems = #selector(FSPagerViewDataSource.numberOfItems(in:))
        static let cellForItemAt = #selector(FSPagerViewDataSource.pagerView(_:cellForItemAt:))
    }
    
    public struct Closure {
        public typealias DidSelected = (Int) -> ()
        public typealias NumberOfItems = () -> Int?
        public typealias CellForItemAt = (FSPagerViewCell) -> ()
    }
    
    public var didSelected: Closure.DidSelected?
    public var numberOfItems: Closure.NumberOfItems?
    public var cellForItemAt: Closure.CellForItemAt?
    public var cornerRadius: CGFloat = 0
    
    fileprivate weak var pagerView: FSPagerView?

    fileprivate var imageItems: [SSBannerImageItem]?
    
    init(pagerView: FSPagerView) {
        super.init()
        self.pagerView = pagerView
        pagerView.delegate = self
        pagerView.dataSource = self
        didSelected = { _ in }
    }
    
}

extension SSBannerDataSource: FSPagerViewDelegate {
    public func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: false)
        guard let didSelected = didSelected else { return }
        didSelected(index)
    }
}

extension SSBannerDataSource: FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let numberOfItems = numberOfItems else { return 0 }
        return numberOfItems() ?? 0
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: SSGuidePageCell.Identifier, at: index)
        cell.tag = index
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        
        cell.imageView?.removeAllSubviews()
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.ss_layerCornerRadius(self.cornerRadius)
        if let cellForItemAt = cellForItemAt {
            cellForItemAt(cell)
        }
        return cell
    }
}
