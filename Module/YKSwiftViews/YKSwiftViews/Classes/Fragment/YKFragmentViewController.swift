//
//  YKFragmentViewController.swift
//  YKSwiftViews
//
//  Created by edward on 2021/12/9.
//

import UIKit

public class YKFragmentViewController: UIViewController {
    
    
    private var dataSource:YKFragmentViewControllerDataSource?
    
    private var mainFrame:CGRect?
    
    private var controllers:[UIViewController] = []
    
    private var lastControllerPage:Int = 0
    
    private var titles:[String] = []
    
    private var headerRight:CGFloat = 0
    
    private var headerLeft:CGFloat = 0
    
    private lazy var headerView:YKFragmentHeaderView = {
        let headerView = YKFragmentHeaderView.init(frame: CGRect.init(x: self.headerLeft, y: 0, width: ((self.mainFrame?.size.width ?? self.view.bounds.size.width) - self.headerLeft - self.headerRight ), height: 44), delegate: self)
        return headerView
    }()
    
    private lazy var lineView:UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: self.headerView.frame.maxY, width: (self.mainFrame?.size.width ?? self.view.bounds.size.width), height: 0.5))
        if let datarSource = self.dataSource {
            lineView.backgroundColor = datarSource.fragmentViewControllerColorForHeaderBottomLine?(self)
        }
        return lineView
    }()
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.lineView.frame.maxY, width: (self.mainFrame?.size.width ?? self.view.bounds.size.width), height: ((self.mainFrame?.size.height ?? self.view.bounds.size.height) - self.lineView.frame.maxY)))
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
 
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        if let dataSource = self.dataSource {
            self.headerLeft = dataSource.fragmentViewControllerHeaderLeftOffset?(self) ?? 0
            self.headerRight = dataSource.fragmentViewControllerHeaderRightOffset?(self) ?? 0
        }
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.lineView)
        self.view.addSubview(self.scrollView)
        
        if self.controllers.count > 0 {
            self.setupControllers()
        }
        
        if let headerBgColor = self.dataSource?.fragmentViewControllerColorForHeaderBackgroundColor?(self) {
            self.headerView.backgroundColor = headerBgColor
        }
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    public convenience init(frame:CGRect, dataSource:YKFragmentViewControllerDataSource, controllers:[UIViewController] = []) {
        self.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
        self.controllers = controllers
        self.mainFrame = frame
        self.view.frame = frame
        self.view.backgroundColor = self.dataSource?.fragmentViewControllerColorForHeaderBackgroundColor?(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: public
public extension YKFragmentViewController {
    
    func addFragment(fromViewController viewController:UIViewController) {
        viewController.addChild(self)
        viewController.view.addSubview(self.view)
    }
    
    func resetControllers(_ controllers:[UIViewController]) {
        self.controllers = controllers
        self.setupControllers()
    }
    
    func reloadBadge() {
        
        for (index,vc) in self.controllers.enumerated() {
            
            if let subFragemtVC = vc as? YKFragmentSubViewControllerDelegate
            {
                subFragemtVC.fragmentSubViewController?(with: { badgeString in
                    self.headerView.setBadge(with: badgeString, index: index)
                })
            }
            
        }
    }
}

//MARK: private
private extension YKFragmentViewController {
    
    func setupControllers() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            var maxWidth:CGFloat = 0
            var titles:[String] = []
            for controller in weakSelf.controllers {
                var title = ""
                if let subVC = controller as? YKFragmentSubViewControllerDelegate {
                    title = subVC.fragmentSubViewControllerTitle?() ?? controller.title ?? NSStringFromClass(controller.classForCoder)
                }
                titles.append(title)
            }
            weakSelf.titles = titles
            weakSelf.headerView.toSetDataSource(weakSelf.titles)
            
            for subVC in weakSelf.children {
                subVC.removeFromParent()
            }
            
            for view in weakSelf.scrollView.subviews {
                view.removeFromSuperview()
            }
            
            for (index,vc) in weakSelf.controllers.enumerated() {
                vc.view.frame = CGRect.init(x: maxWidth, y: weakSelf.view.bounds.origin.y, width: weakSelf.scrollView.bounds.size.width, height: weakSelf.scrollView.bounds.size.height)
                
                if let dataSource = weakSelf.dataSource {
                    let badge = dataSource.fragmentViewController?(weakSelf, badgeAt: IndexPath.init(row: index, section: 0)) ?? ""
                    weakSelf.headerView.setBadge(with: badge, index: index)
                }
                
                if let subFragmentVC = vc as? YKFragmentSubViewControllerDelegate {
                    subFragmentVC.fragmentSubViewController?(with: { [weak self] badgeString in
                        guard let wSelf = self else { return }
                        wSelf.headerView.setBadge(with: badgeString, index: index)
                    })
                }
                weakSelf.addChild(vc)
                weakSelf.scrollView.addSubview(vc.view)
                maxWidth = maxWidth + vc.view.frame.size.width
            }
            weakSelf.scrollView.contentSize = CGSize.init(width: maxWidth, height: weakSelf.scrollView.bounds.size.height)
        }
    }
}

//MARK: UIScrollViewDelegate
extension YKFragmentViewController: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        self.headerView.loadCurrent(with: currentIndex)
        if self.lastControllerPage != currentIndex,
           let dataSource = self.dataSource,
           let subFragmentVC = self.controllers[currentIndex] as? YKFragmentSubViewControllerDelegate
        {
            dataSource.fragmentViewController?(self, subViewControllerViewDidApper: subFragmentVC)
        }
        self.lastControllerPage = currentIndex
    }
}

//MARK: YKFragmentHeaderViewDelegate
extension YKFragmentViewController: YKFragmentHeaderViewDelegate {
    
    func didSelect(fragmentHeaderView headerView: YKFragmentHeaderView, at indexPath: IndexPath) {
        let scrollToPoint = CGPoint.init(x: (CGFloat(indexPath.row) * self.scrollView.bounds.size.width), y: self.scrollView.contentOffset.y)
        self.scrollView.setContentOffset(scrollToPoint, animated: true)
        self.lastControllerPage = indexPath.row
        if let dataSource = self.dataSource,
           let subFragmentVC = self.controllers[indexPath.row] as? YKFragmentSubViewControllerDelegate
        {
            dataSource.fragmentViewController?(self, subViewControllerViewDidApper: subFragmentVC)
        }
    }
    
    
    
    func configForItem(at indexPath: IndexPath) -> YKFragmentTopConfig {
        return self.dataSource?.fragmentViewController(self, configForHeaderItem: indexPath) ?? YKFragmentTopConfig.init()
    }
    
    func widthForItem(at indexPath: IndexPath, titleString title: String) -> CGFloat {
        return self.dataSource?.fragmentViewController?(self, widthForHeaderItem: indexPath, title: title) ?? 0
    }
    
    func widthForItemLabel(at indexPath: IndexPath, titleString title: String) -> CGFloat {
        return self.dataSource?.fragmentViewController?(self, widthForHeaderItemLabel: indexPath, title: title) ?? 0
    }
    
    func heightForItemLabel(at indexPath: IndexPath, titleString title: String) -> CGFloat {
        return self.dataSource?.fragmentViewController?(self, heightForHeaderItemLabel: indexPath, title: title) ?? 0
    }
    
    func sizeForHeaderCursorImageView() -> CGSize {
        return self.dataSource?.fragmentViewControllerSizeForCursorImageView?(self) ?? CGSize.zero
    }
    
    func imageForHeaderCursorImageView() -> UIImage? {
        return self.dataSource?.fragmentViewControllerImageForCursorImageView?(self)
    }
    
    func backgroundColorForHeaderCursorImageView() -> UIColor {
        return self.dataSource?.fragmentViewControllerBackgroundColorForCursorImageView?(self) ?? .clear
    }
    
    func badgeOffsetForItem(at indexPath: IndexPath) -> UIOffset {
        return self.dataSource?.fragmentViewController?(self, badgeOffsetAt: indexPath) ?? UIOffset.zero
    }
    
    
    
    
}
