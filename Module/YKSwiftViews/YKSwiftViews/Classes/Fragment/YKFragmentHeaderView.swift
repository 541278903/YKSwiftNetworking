//
//  YKFragmentHeaderView.swift
//  YKSwiftViews
//
//  Created by edward on 2021/12/9.
//

import UIKit

internal protocol YKFragmentHeaderViewDelegate: NSObjectProtocol {
    
    func didSelect(fragmentHeaderView headerView:YKFragmentHeaderView, at indexPath:IndexPath)
    
    func configForItem(at indexPath:IndexPath) -> YKFragmentTopConfig
    
    func widthForItem(at indexPath:IndexPath, titleString title:String) -> CGFloat
    
    func widthForItemLabel(at indexPath:IndexPath, titleString title:String) -> CGFloat
    
    func heightForItemLabel(at indexPath:IndexPath, titleString title:String) -> CGFloat
    
    func sizeForHeaderCursorImageView() -> CGSize
    
    func imageForHeaderCursorImageView() -> UIImage?
    
    func backgroundColorForHeaderCursorImageView() -> UIColor
    
    func badgeOffsetForItem(at indexPath:IndexPath) -> UIOffset
    
}

internal class YKFragmentHeaderView: UIView {

    private weak var delegate:YKFragmentHeaderViewDelegate?
    
    private var badges:[String] = []
    
    private var dataSource:[String] = []
    
    private var cursorImageViewSize:CGSize = CGSize.zero
    
    private var lastControllerPage:Int = 0
    
    private lazy var layout:UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.backgroundColor = self.backgroundColor
        collectionView.bounces = false
        collectionView.layer.borderColor = self.backgroundColor?.cgColor
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.register(YKFragmentHeaderCell.self, forCellWithReuseIdentifier: NSStringFromClass(YKFragmentHeaderCell.self))
        
        return collectionView
    }()
    
    private lazy var cursorImageView:UIImageView = {
        
        let firstWidth:CGFloat = self.delegate?.widthForItem(at: IndexPath.init(item: 0, section: 0), titleString: self.badges.first ?? "") ?? 0
        let cursorImageView = UIImageView.init(frame: CGRect.init(x: (firstWidth - self.cursorImageViewSize.width)/2, y: (self.bounds.size.height - self.cursorImageViewSize.height), width: self.cursorImageViewSize.width, height: self.cursorImageViewSize.height))
        
        if let image = self.delegate?.imageForHeaderCursorImageView() {
            cursorImageView.image = image
        }else {
            cursorImageView.backgroundColor = self.delegate?.backgroundColorForHeaderCursorImageView()
            cursorImageView.layer.cornerRadius = self.cursorImageViewSize.height/2
            cursorImageView.clipsToBounds = true
        }
        
        
        return cursorImageView
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal convenience init(frame:CGRect, delegate:YKFragmentHeaderViewDelegate) {
        self.init(frame: frame)
        self.delegate = delegate
        self.cursorImageViewSize = delegate.sizeForHeaderCursorImageView()
        setupUI()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: private
private extension YKFragmentHeaderView {
    
    private func setupUI() {
        self.addSubview(self.collectionView)
        self.collectionView.addSubview(self.cursorImageView)
    }
    
    private func bindData() {
        
    }
    
    private func reload() {
        self.collectionView.reloadData()
    }
    
}

//MARK: internal
internal extension YKFragmentHeaderView {
    
    func loadCurrent(with index:Int) {
        
        if index == 0 {
            self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .left, animated: true)
        }else if index == (self.dataSource.count - 1) {
            self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .right, animated: true)
        }else if self.lastControllerPage < index {
            if (index + 1) == (self.dataSource.count - 1) {
                self.collectionView.scrollToItem(at: IndexPath.init(row: (self.dataSource.count - 1), section: 0), at: .right, animated: true)
            }else {
                self.collectionView.scrollToItem(at: IndexPath.init(row: (index + 1), section: 0), at: .right, animated: true)
            }
        }else if self.lastControllerPage > index {
            if (index - 1) == 0 {
                self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .left, animated: true)
            }else {
                self.collectionView.scrollToItem(at: IndexPath.init(row: (index - 1), section: 0), at: .left, animated: true)
            }
        }
        self.lastControllerPage = index
        var cursorCenter:CGFloat = 0
        
        for i in 0...index {
            var cursorWidth:CGFloat = 0
            if let delegate = self.delegate {
                cursorWidth = delegate.widthForItem(at: IndexPath.init(row: i, section: 0), titleString: self.dataSource[i])
            }
            if i == index {
                cursorCenter = cursorCenter + (cursorWidth/2)
            }else {
                cursorCenter = cursorCenter + cursorWidth
            }
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.cursorImageView.center = CGPoint.init(x: cursorCenter, y: weakSelf.bounds.size.height - (weakSelf.cursorImageViewSize.height/2))
        } completion: { isFinish in
            
        }

        self.reload()
    }
    
    func setBadge(with badge:String, index:Int) {
        if index < self.badges.count {
            self.badges[index] = badge
        }
        self.reload()
    }
    
    func toSetDataSource(_ dataSource:[String]) {
        self.dataSource = dataSource
        var badges:[String] = []
        for _ in self.dataSource {
            badges.append("")
        }
        self.badges = badges
        self.reload()
        if dataSource.count > 0 {
            self.loadCurrent(with: 0)
        }
    }
}

//MARK: UICollectionViewDataSource
extension YKFragmentHeaderView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(YKFragmentHeaderCell.self), for: indexPath)
        
        if let headerCell = cell as? YKFragmentHeaderCell,
           let delegate = self.delegate
        {
            headerCell.setDetail(titleString: self.dataSource[indexPath.row])
            headerCell.setDetail(config: delegate.configForItem(at: indexPath))
            headerCell.setDetail(badge: self.badges[indexPath.row])
            headerCell.setDetail(height: delegate.heightForItemLabel(at: indexPath, titleString: self.dataSource[indexPath.row]))
            headerCell.setDetail(width: delegate.widthForItemLabel(at: indexPath, titleString: self.dataSource[indexPath.row]))
            headerCell.setDetail(offset: delegate.badgeOffsetForItem(at: indexPath))
        }
        
        return cell
    }
    
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension YKFragmentHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.loadCurrent(with: indexPath.row)
        self.delegate?.didSelect(fragmentHeaderView: self, at: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.delegate?.widthForItem(at: indexPath, titleString: self.dataSource[indexPath.row]) ?? 0
        return CGSize.init(width: width, height: collectionView.bounds.size.height)
    }
    
}
