//
//  YKNavigationController.swift
//  YKSwiftBaseClass
//
//  Created by linghit on 2021/11/17.
//

import UIKit


open class YKNavigationController : UINavigationController,UINavigationControllerDelegate
{
    
    public var backBtn:UIButton = UIButton(type: .custom)
    
    public var backBtnItem:UIBarButtonItem = UIBarButtonItem.init()
    
    private var _foregroundColor:UIColor = .white
    public var foregroundColor:UIColor{
        get{
            return _foregroundColor
        }
        set{
            _foregroundColor = newValue
            var barTitleDic = Dictionary<NSAttributedString.Key,Any>.init()
            barTitleDic[NSAttributedString.Key.foregroundColor] = newValue
            UINavigationBar.appearance().titleTextAttributes = barTitleDic
        }
    }
    
    private var _backgroundColor:UIColor = .white
    public var backgroundColor:UIColor{
        get{
            return _backgroundColor
        }
        set{
            _backgroundColor = newValue
            if #available(iOS 15.0, *) {
                let standardAppearance = navigationBar.standardAppearance
                standardAppearance.backgroundColor = newValue
                navigationBar.standardAppearance = standardAppearance
                
                let scrollEdgeAppearance = navigationBar.scrollEdgeAppearance ?? UINavigationBarAppearance.init()
                scrollEdgeAppearance.backgroundColor = newValue
                navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
            } else {
                navigationBar.barTintColor = newValue
                navigationBar.backgroundColor = newValue
            }
        }
    }
    
    private var _shadowImage:UIImage = UIImage.init()
    public var shadowImage:UIImage{
        get{
            return _shadowImage
        }
        set{
            _shadowImage = newValue
            navigationBar.shadowImage = newValue
        }
    }
    
    private var _tabbarBackgroundColor:UIColor = .white
    public var tabbarBackgroundColor:UIColor{
        get{
            return _tabbarBackgroundColor
        }
        set{
            _tabbarBackgroundColor = newValue
            if #available(iOS 15, *) {
                let scrollAppearance = tabBarItem.scrollEdgeAppearance ?? UITabBarAppearance.init()
                scrollAppearance.backgroundColor = newValue
                tabBarItem.scrollEdgeAppearance = scrollAppearance
                
                let standardAppearance = tabBarItem.standardAppearance ?? UITabBarAppearance.init()
                standardAppearance.backgroundColor = newValue
                tabBarItem.standardAppearance = standardAppearance
                
            } else {
                UITabBar.appearance().tintColor = newValue
            }
        }
    }
    
    private var _tabbarNormalItemTextColor:UIColor = .white
    public var tabbarNormalItemTextColor:UIColor{
        get{
            return _tabbarNormalItemTextColor
        }
        set{
            _tabbarNormalItemTextColor = newValue
            if #available(iOS 15, *) {
                let scrollAppearance = tabBarItem.scrollEdgeAppearance ?? UITabBarAppearance.init()
                var scrollNormalAttributes = scrollAppearance.stackedLayoutAppearance.normal.titleTextAttributes
                scrollNormalAttributes[NSAttributedString.Key.foregroundColor] = newValue
                scrollAppearance.stackedLayoutAppearance.normal.titleTextAttributes = scrollNormalAttributes
                tabBarItem.scrollEdgeAppearance = scrollAppearance
                
                let standardAppearance = tabBarItem.standardAppearance ?? UITabBarAppearance.init()
                var standardNormalAttributes = standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes
                standardNormalAttributes[NSAttributedString.Key.foregroundColor] = newValue
                standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes = standardNormalAttributes
                tabBarItem.standardAppearance = standardAppearance
                
            } else {
                UITabBar.appearance().tintColor = newValue
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:newValue], for: .normal)
            }
        }
    }
    
    private var _tabbarSelectItemTextColor:UIColor = .white
    public var tabbarSelectItemTextColor:UIColor{
        get{
            return _tabbarSelectItemTextColor
        }
        set{
            _tabbarSelectItemTextColor = newValue
            if #available(iOS 15, *) {
                let scrollAppearance = tabBarItem.scrollEdgeAppearance ?? UITabBarAppearance.init()
                var scrollSelectedAttributes = scrollAppearance.stackedLayoutAppearance.selected.titleTextAttributes
                scrollSelectedAttributes[NSAttributedString.Key.foregroundColor] = newValue
                scrollAppearance.stackedLayoutAppearance.selected.titleTextAttributes = scrollSelectedAttributes
                tabBarItem.scrollEdgeAppearance = scrollAppearance
                
                let standardAppearance = tabBarItem.standardAppearance ?? UITabBarAppearance.init()
                var standardSelectedAttributes = standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes
                standardSelectedAttributes[NSAttributedString.Key.foregroundColor] = newValue
                standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes = standardSelectedAttributes
                tabBarItem.standardAppearance = standardAppearance
                
            } else {
                UITabBar.appearance().tintColor = newValue
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:newValue], for: .normal)
            }
        }
    }
    
    private var _tabbarSelectedImage:UIImage = UIImage.init()
    public var tabbarSelectedImage:UIImage{
        get{
            return _tabbarSelectedImage
        }
        set{
            _tabbarSelectedImage = newValue
            tabBarItem.selectedImage = newValue
        }
    }
    
    private var _tabbarNormalImage:UIImage = UIImage.init()
    public var tabbarNormalImage:UIImage{
        get{
            return _tabbarNormalImage
        }
        set{
            _tabbarNormalImage = newValue
            tabBarItem.image = newValue
        }
    }
    
    private var _tabbarTitle:String = ""
    public var tabbarTitle:String{
        get{
            return _tabbarTitle
        }
        set{
            _tabbarTitle = newValue
            tabBarItem.title = newValue
        }
    }
    
    private var _backBtnTitle:String? = nil
    public var backBtnTitle:String?{
        get{
            return _backBtnTitle
        }
        set{
            _backBtnTitle = newValue
            
            
            self.backBtn.setTitle(newValue, for: .normal)
            if #available(iOS 13.0, *) {
                self.backBtn.setTitleColor(.label, for: .normal)
            } else {
                self.backBtn.setTitleColor(.black, for: .normal)
            }
            let ipad = UIDevice.current.userInterfaceIdiom == .pad ? 2: 1;
            var frame = self.backBtn.frame
            frame.size = CGSize(width: 44 * ipad, height: 44 * ipad)
            self.backBtn.frame = frame
            self.backBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
            self.backBtn.contentHorizontalAlignment = .left
        }
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        var childrenVCs:[UIViewController] = []
        #if swift(>=4.2)
            childrenVCs = self.children
        #else
            childrenVCs = self.childViewControllers
        #endif
        
        if childrenVCs.count > 0 {
            let backBtn = UIButton.init(type: .custom)
            var url = ""
            let bundle = Bundle(for: YKNavigationController.self)
            if #available(iOS 13.0, *) {
                if traitCollection.userInterfaceStyle == .dark {
                    url = bundle.path(forResource: "ic_bc_back_while@3x", ofType: "png") ?? "ic_bc_back_while@3x.png"
                    
                }else{
                    url = bundle.path(forResource: "ic_bc_back_black@3x", ofType: "png") ?? "ic_bc_back_black@3x.png"
                }
                backBtn.setTitleColor(.label, for: .normal)
            } else {
                url = bundle.path(forResource: "ic_bc_back_black@3x", ofType: "png") ?? "ic_bc_back_black@3x.png"
                backBtn.setTitleColor(.black, for: .normal)
            }
            var backImage = UIImage.init(contentsOfFile: url)
            if backImage != nil {
                backImage = backImage!.withRenderingMode(.alwaysTemplate)
            }
            backBtn.setImage(backImage, for: .normal)
            backBtn.setImage(backImage, for: .highlighted)
            
            backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            
            let ipad = UIDevice.current.userInterfaceIdiom == .pad ? 2: 1;
            var frame = backBtn.frame
            frame.size = CGSize(width: 44 * ipad, height: 44 * ipad)
            backBtn.frame = frame
            backBtn.contentHorizontalAlignment = .left
            backBtn.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
            backBtn.sizeToFit()
            
            self.backBtn = backBtn
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
            
            
            self.backBtnItem = viewController.navigationItem.leftBarButtonItem!
            
            if viewControllers.count == 1 {
                viewController.hidesBottomBarWhenPushed = true
            }
            
        }else{
            viewController.hidesBottomBarWhenPushed = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc open func back(sender:AnyObject)->Void
    {
        self.popViewController(animated: true)
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .default
    }
}
