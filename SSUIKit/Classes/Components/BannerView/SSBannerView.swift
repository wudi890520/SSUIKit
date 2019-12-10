//
//  SSBannerView.swift
//  DeviceKit
//
//  Created by 吴頔 on 2019/12/9.
//

import UIKit
import FSPagerView
import RxSwift
import RxCocoa

public class SSBannerView: UIView {

    public lazy var bannerView: FSPagerView = {
        let view = FSPagerView(frame: .zero)
        view.automaticSlidingInterval = 5
        view.isInfinite = true
        view.register(SSGuidePageCell.self, forCellWithReuseIdentifier: SSGuidePageCell.Identifier)
        
        if let size = self.itemSize {
            view.itemSize = size
        }
        
        if isNeedTransformer {
            let transformer = FSPagerViewTransformer(type: .linear)
            transformer.minimumScale = 0.66
            transformer.minimumAlpha = 1
            view.transformer = transformer
        }
        
        return view
    }()
    
    public lazy var dataSource: SSBannerDataSource = {
        let dataSource = SSBannerDataSource(pagerView: self.bannerView)
        return dataSource
    }()
    
    private var itemSize: CGSize?
    private var isNeedTransformer = false
    
    public init(isNeedTransformer: Bool = false, itemSize: CGSize? = nil) {
        super.init(frame: .zero)
        self.isNeedTransformer = isNeedTransformer
        self.itemSize = itemSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
