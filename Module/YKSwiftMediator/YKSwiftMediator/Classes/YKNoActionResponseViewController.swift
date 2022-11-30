//
//  YKNoActionResponseViewController.swift
//  YK_Swift_MainMediator
//
//  Created by edward on 2021/5/24.
//

import UIKit

class YKNoActionResponseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.pageSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        let titleLable = UILabel.init()
        titleLable.text = "📶"
        titleLable.bounds = CGRect(x: 0, y: 0, width: 120, height: 120)
        titleLable.textAlignment = NSTextAlignment.center
        titleLable.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        titleLable.center = CGPoint(x: view.bounds.size.width/2, y: (view.bounds.size.height - 200)/2)
        
        let tipLabel = UILabel.init()
        tipLabel.frame = CGRect(x: 0, y: titleLable.frame.maxY + 10, width: 0, height: 0)
        tipLabel.text = "功能正在开发中...敬请期待"
        tipLabel.sizeToFit()
        let point = CGPoint(x: view.bounds.size.width/2, y: tipLabel.center.y)
//        point.x = view.bounds.size.width/2x
        tipLabel.center = point
        tipLabel.numberOfLines = 1
        
        let backButton = UIButton.init(type: .system)
        backButton.frame = CGRect(x: 0, y: tipLabel.frame.maxY + 10, width: 0, height: 0)
        backButton.setTitle("点击返回", for: .normal)
        backButton.sizeToFit()
        let buttonCenter = CGPoint(x: view.bounds.size.width/2, y: backButton.center.y)
        backButton.center = buttonCenter
        backButton.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        
        view.addSubview(titleLable)
        view.addSubview(tipLabel)
        view.addSubview(backButton)
    }
    
    @objc func back(sender:AnyObject)->Void
    {
        if self.navigationController != nil {
            if self.navigationController!.presentingViewController != nil && self.navigationController?.viewControllers.count == 1 {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
