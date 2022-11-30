//
//  YKFragmentHeaderCell.swift
//  YKSwiftViews
//
//  Created by edward on 2021/12/9.
//

import UIKit

internal class YKFragmentHeaderCell: UICollectionViewCell {
    
    private let badgeHeight:CGFloat = 15
    private let badgeFarFrom:CGFloat = 5
    private var badgeOffset:UIOffset = UIOffset.init(horizontal: 0, vertical: 0)
    
    private var badgeWidth:CGFloat {
        get {
            self.badgeLabel.frame.size.width
        }
    }
    
    private lazy var mainLabel:UILabel = {
        let label = UILabel.init(frame: self.bounds)
        label.textAlignment = .center
        label.center = CGPoint.init(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        return label
    }()
    
    private lazy var badgeLabel:UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: (self.bounds.size.width - self.badgeFarFrom), y: self.badgeFarFrom, width: 0, height: self.badgeHeight))
        label.backgroundColor = .red
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        label.layer.cornerRadius = self.badgeHeight/2
        label.numberOfLines = 1
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.badgeOffset = UIOffset.init(horizontal: 0, vertical: 0)
        self.addSubview(self.mainLabel)
        self.addSubview(self.badgeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal extension YKFragmentHeaderCell {
    
    func setDetail(config:YKFragmentTopConfig) {
        
        if isSelected {
            self.mainLabel.textColor = config.titleSelectColor
            self.mainLabel.backgroundColor = config.titleSelectBgColor
            self.mainLabel.font = config.titleSelectFont
            self.mainLabel.layer.cornerRadius = config.titleSelectCornerRadius
        }else {
            self.mainLabel.textColor =  config.titleNormalColor
            self.mainLabel.backgroundColor = config.titleNormalBgColor
            self.mainLabel.font = config.titleNormalFont
            self.mainLabel.layer.cornerRadius = config.titleNormalCornerRadius
        }
        self.mainLabel.clipsToBounds = true
        self.mainLabel.center = CGPoint.init(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        self.resetBadgeWidth()
        
    }
    
    func setDetail(offset:UIOffset) {
        self.badgeOffset = offset
        self.resetBadgeWidth()
    }
    
    func setDetail(badge:String) {
        if badge.count > 0 {
            self.badgeLabel.isHidden = false
            self.badgeLabel.text = badge
            self.badgeLabel.sizeToFit()
            self.resetBadgeWidth()
        }else {
            self.badgeLabel.isHidden = true
        }
    }
    
    func setDetail(height:CGFloat) {
        var bound = self.mainLabel.bounds
        if height > 0 {
            bound.size.height = height
        }else {
            bound.size.height = self.bounds.size.height
        }
        self.mainLabel.bounds = bound
    }
    
    func setDetail(width:CGFloat) {
        var bound = self.mainLabel.bounds
        if width > 0 {
            bound.size.width = width
        }else {
            bound.size.width = self.bounds.size.width
        }
        self.mainLabel.bounds = bound
    }
    
    func setDetail(titleString:String) {
        self.mainLabel.text = titleString
    }
}

private extension YKFragmentHeaderCell {
    
    func resetBadgeWidth() {
        let badgeW = badgeWidth < 17 ? 17 : badgeWidth
        let badgeX = self.bounds.size.width - self.badgeFarFrom - badgeW + self.badgeOffset.horizontal
        let badgeY = badgeFarFrom + self.badgeOffset.vertical
        let badgeH = badgeHeight
        self.badgeLabel.frame = CGRect.init(x: badgeX, y: badgeY, width: badgeW, height: badgeH)
    }
}
