//
//  YKSwiftAlertCenter.swift
//  YKSwiftAlert
//
//  Created by edward on 2021/9/22.
//

import UIKit
import QuartzCore


public class YKSwiftAlertCenter: NSObject {

    public static func showMessage(message:String)->Void
    {
        if UIApplication.shared.keyWindow != nil {
            YKSwiftAlertCenter.showMessage(message: message, inView: UIApplication.shared.keyWindow!)
        }
    }
    
    public static func showMessage(message:String, inView:UIView)->Void
    {
        DispatchQueue.main.async {
            YKSwiftAlertCenter.dissLoading()
            
            if message.count <= 0 {
                return
            }
            
            // 删除旧的先
            var beforeView = inView.viewWithTag(YKSwiftAlertCenter.kYK_AlertMessage_Tag())
            if beforeView != nil {
                beforeView!.removeFromSuperview()
                beforeView = nil
            }
            
            let isPad:Bool = UI_USER_INTERFACE_IDIOM() == .pad
            let showW:CGFloat = (isPad) ? 200 : 150
            let showH:CGFloat = (isPad) ? 45 : 25
            let spacX:CGFloat = (isPad) ? 10 : 10
            
            let showFont:UIFont = UIFont.systemFont(ofSize: isPad ? 24 : 16)
            let nsMessage:NSString = NSString(string: message)
            var theStringSize:CGSize = nsMessage.boundingRect(with: CGSize.init(width: showW-spacX*2, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:showFont], context: nil).size
            
            if theStringSize.height<showH {
                theStringSize.height = showH
            }
            
            // 背景
            let showView:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: showW, height: theStringSize.height+spacX*2))
            showView.tag = YKSwiftAlertCenter.kYK_AlertMessage_Tag()
            showView.alpha = 0
            showView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            showView.layer.cornerRadius = isPad ? 10 : 7
            showView.layer.masksToBounds = true
            showView.center = CGPoint(x: inView.frame.size.width/2, y: inView.frame.size.height/2)
            inView.addSubview(showView)
            
            // 内容
            
            let showLabel:UILabel = UILabel.init(frame: CGRect.init(x: spacX, y: spacX, width: showW - spacX*2, height: theStringSize.height))
            showLabel.textAlignment = .center
            showLabel.numberOfLines = 0
            showLabel.text = message
            showLabel.textColor = .white
            showLabel.backgroundColor = .clear
            showLabel.font = showFont
            showView.addSubview(showLabel)
            
            // 动画
            var tempView:UIView? = showView
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if tempView != nil {
                    tempView!.removeFromSuperview()
                    tempView = nil
                }
            }
            let keyAnim:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "opacity")
            keyAnim.values = [0,1,1,0]
            keyAnim.keyTimes = [0,0.1,0.9,1]
            keyAnim.duration = 2
            keyAnim.repeatCount = 1
            showView.layer.add(keyAnim, forKey: nil)
            CATransaction.commit()
        }
        
    }
    
    public static func showLoading(message:String)->Void
    {
        DispatchQueue.main.async {
            
            let isPad:Bool = UI_USER_INTERFACE_IDIOM() == .pad
            var showW:CGFloat = (isPad) ? 200 : 150
            let showH:CGFloat = (isPad) ? 45 : 25
            let spacX:CGFloat = (isPad) ? 10 : 10
            let activityW:CGFloat = 20
            
            let showFont:UIFont = UIFont.systemFont(ofSize: isPad ? 24 : 16)
            let nsMessage:NSString = NSString(string: message)
            var theStringSize:CGSize = nsMessage.boundingRect(with: CGSize.init(width: showW-spacX*2-activityW, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:showFont], context: nil).size
            
            if theStringSize.height<showH {
                theStringSize.height = showH
            }
            
            let keyWindow:UIView? = UIApplication.shared.keyWindow
            if keyWindow == nil {
                return
            }
            
            var bgView:UIView? = keyWindow!.viewWithTag(YKSwiftAlertCenter.kYK_AlertMessage_Tag())
            
            let needCreateView:Bool = bgView == nil
            
            if needCreateView {
                bgView = UIView.init()
                bgView!.alpha = 0
                bgView!.tag = YKSwiftAlertCenter.kYK_AlertLoading_Tag()
                bgView!.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                UIApplication.shared.keyWindow!.addSubview(bgView!)
            }
            bgView!.frame = CGRect(x: 0, y: 0, width: keyWindow!.frame.size.width, height: keyWindow!.frame.size.height)
            
            
            var showView:UIView? = bgView!.viewWithTag(YKSwiftAlertCenter.kYK_AlertLoading_View_Tag())
            if message.count > 0 {

            } else {
                showW = theStringSize.height + spacX * 2
            }

            if needCreateView {
                showView = UIView.init()
                showView!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                showView!.layer.cornerRadius = isPad ? 10 : 7
                showView!.layer.masksToBounds = true
                showView!.tag = YKSwiftAlertCenter.kYK_AlertLoading_View_Tag()
                bgView!.addSubview(showView!)
            }

            showView!.frame = CGRect(x: 0, y: 0, width: showW, height: theStringSize.height + spacX * 2)
            showView!.center = CGPoint(x: keyWindow!.frame.size.width/2, y: keyWindow!.frame.size.height/2)

            if message.count > 0 {
                var showLabel:UILabel? = bgView!.viewWithTag(YKSwiftAlertCenter.kYK_AlertLoading_Label_Tag()) as? UILabel
                if needCreateView {
                    showLabel = UILabel.init()
                    showLabel!.textAlignment = .center
                    showLabel!.numberOfLines = 0
                    showLabel!.textColor = .white
                    showLabel!.backgroundColor = .clear
                    showLabel!.font = showFont
                    showLabel!.tag = YKSwiftAlertCenter.kYK_AlertLoading_Label_Tag()
                    showView!.addSubview(showLabel!)
                }

                showLabel!.frame = CGRect(x: spacX+activityW, y: spacX, width: showW-spacX*2-activityW, height: theStringSize.height)
                showLabel!.text = message

            }

            var activityView:UIActivityIndicatorView? = nil

            if needCreateView {
                activityView = UIActivityIndicatorView.init()
                activityView!.color = .white
                showView!.addSubview(activityView!)
            }

            if message.count > 0 {
                activityView!.center = CGPoint(x: spacX+activityW/2, y: showView!.frame.size.height/2)
            } else {
                activityView!.center = CGPoint(x: showView!.frame.size.width/2, y: showView!.frame.size.height/2)
            }

            activityView!.startAnimating()

            if needCreateView {
                UIView.animate(withDuration: 0.2) {
                    bgView!.alpha = 1
                }
            }
        }
        
    }

    public static func dissLoading()->Void
    {
        DispatchQueue.main.async {
            if UIApplication.shared.keyWindow != nil {
                let tempView:UIView? = UIApplication.shared.keyWindow!.viewWithTag(YKSwiftAlertCenter.kYK_AlertLoading_Tag())
                if tempView != nil {
                    tempView!.removeFromSuperview()
                }
            }
        }
    }
    
    private static func kYK_AlertMessage_Tag()->Int
    {
        return 889
    }
    
    private static func kYK_AlertLoading_Tag()->Int
    {
        return 888
    }
    
    private static func kYK_AlertLoading_Label_Tag()->Int
    {
        return 890
    }
    
    private static func kYK_AlertLoading_View_Tag()->Int
    {
        return 891
    }
}
