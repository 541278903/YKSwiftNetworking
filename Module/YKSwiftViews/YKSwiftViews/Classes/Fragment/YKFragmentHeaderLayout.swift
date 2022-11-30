//
//  YKFragmentHeaderLayout.swift
//  YKSwiftViews
//
//  Created by edward on 2021/12/9.
//

import UIKit

internal protocol YKFragmentHeaderLayoutDelegate: NSObjectProtocol {
    
    func withForItem(at indexPath:IndexPath) -> CGFloat
    
    func finalContentSize(contentSize:CGSize)
}

internal class YKFragmentHeaderLayout: UICollectionViewFlowLayout {
    
    private weak var delegate:YKFragmentHeaderLayoutDelegate?
    
    private var layoutAttributes:[UICollectionViewLayoutAttributes] = []
    
    private var lastMaxX:CGFloat = 0

    internal override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(delegate:YKFragmentHeaderLayoutDelegate) {
        self.init()
        self.lastMaxX = 0
        self.estimatedItemSize = CGSize.zero
        self.scrollDirection = .vertical
        self.delegate = delegate
    }
    
    override func prepare() {
        let sections = self.collectionView?.numberOfSections ?? 0
        self.lastMaxX = 0
        
        for i in 0..<sections {
            let itemCount = self.collectionView?.numberOfItems(inSection: i) ?? 0
            for j in 0..<itemCount {
                let indexPath = IndexPath.init(item: j, section: i)
                let attr = self.layoutAttributesForItem(at: indexPath)!
                self.layoutAttributes.append(attr)
            }
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attri = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let attriX = self.lastMaxX
        let attriY:CGFloat = 0
        var attriWidth:CGFloat = 0
        if let delegate = self.delegate {
            attriWidth = delegate.withForItem(at: indexPath)
        }
        let attriHeigh = self.collectionView?.bounds.size.height ?? 0
        attri.frame = CGRect.init(x: attriX, y: attriY, width: attriWidth, height: attriHeigh)
        self.lastMaxX = self.lastMaxX + attriWidth
        return attri
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.layoutAttributes
    }
    
    
}

private extension YKFragmentHeaderLayout {
    
    
    
}
