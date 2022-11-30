//
//  YKSectionNoDataView.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2021/12/8.
//

import UIKit

public class YKSectionNoDataView: UIView {
    
    internal var reloadCallBack:(()->Void)?
    
    public let tipLabel:UILabel = {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = "暂无更多数据"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    public let tipImageView:UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let bundle = Bundle(for: YKSectionNoDataView.self)
        let url = bundle.path(forResource: "ic_sectionvm_nodata_image", ofType: "png") ?? "ic_sectionvm_nodata_image.png"
        imageView.image = UIImage.init(contentsOfFile: url)
        return imageView
    }()
    
    internal let reloadButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("点击刷新", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let loadingView:UIView = {
        let view = UIView.init()
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        tipImageView.frame = CGRect(x: (self.bounds.size.width - 100)/2, y: (self.bounds.size.height - 350)/2, width: 100, height: 100)
        tipLabel.frame = CGRect(x: 0, y: tipImageView.frame.maxY + 30, width: self.bounds.size.width, height: 30)
        reloadButton.frame = CGRect(x: (self.bounds.size.width - 100)/2, y: tipLabel.frame.maxY + 10, width: 100, height: 30)
        reloadButton.addTarget(self, action: #selector(reloadClick(sender:)), for: .touchUpInside)
        loadingView.center = self.center
        self.addSubview(tipLabel)
        self.addSubview(tipImageView)
        self.addSubview(reloadButton)
    }
    
    @objc private func reloadClick(sender:UIButton) {
        if self.reloadCallBack != nil {
            self.reloadCallBack!()
        }
    }
    
    internal func setHidden(hidden:Bool) {
        self.isHidden = hidden
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func isShowNoData(noData:Bool) {
        self.tipLabel.isHidden = !noData
        self.tipImageView.isHidden = !noData
        self.reloadButton.isHidden = !noData
    }

}
