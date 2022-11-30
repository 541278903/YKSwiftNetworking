//
//  YKLoopView.swift
//  YKSwiftViews
//
//  Created by edward on 2022/7/3.
//

import UIKit

public class YKLoopView: UIView {
    
    private let layout = UICollectionViewFlowLayout()
    
    private lazy var collectionView:UICollectionView = {
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

}

public extension YKLoopView {
    
    func resetData(with images:[UIImage]) {
         
    }
    
    func resetData(with imageStrs:[String]) {
         
    }
}

private extension YKLoopView {
    
}

extension YKLoopView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension YKLoopView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        
        return cell
    }
}
