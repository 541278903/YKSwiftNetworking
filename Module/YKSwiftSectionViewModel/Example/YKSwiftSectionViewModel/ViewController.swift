//
//  ViewController.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 08/16/2022.
//  Copyright (c) 2022 edward. All rights reserved.
//

import UIKit
import YKSwiftSectionViewModel

class ViewController: UIViewController {
    
    private lazy var collectionView:YKSectionCollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        let collectionView = YKSectionCollectionView.init(frame: self.view.bounds, layout: flowLayout, datas: [])
        collectionView.backgroundColor = UIColor.white
        
        collectionView.toSetEndRefresh { isNoMoreData in
            
        }
        
        collectionView.toSetErrorCallBack { error in
            
        }
        
        collectionView.toSetHandleViewController { [weak self] controller, type, animated in
            guard let weakSelf = self else { return }
            switch type {
            case .Push:
//                weakSelf.currentNavViewController()?.pushViewController(controller, animated: true)
                weakSelf.navigationController?.pushViewController(controller, animated: animated)
            case .Present:
                weakSelf.present(controller, animated: animated, completion: nil)
            }
        }
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

