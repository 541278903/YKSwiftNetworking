//
//  UIButton+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2021/10/21.
//

import UIKit

extension UIButton
{
    private struct AssociatedKey {
        static var eventKey: String = "eventKey"
    }
    
    @objc private func yk_eventAction(sender: UIButton) -> Void {
        guard let eventCallBack = objc_getAssociatedObject(self,&AssociatedKey.eventKey) as? ((_ sender:UIButton)->Void) else { return }
        eventCallBack(sender)
    }
    
    public func yk_addEvent(event: UIControl.Event, eventCallBack:@escaping (_ sender:UIButton)->Void) -> Void {
        objc_setAssociatedObject(self,&AssociatedKey.eventKey,eventCallBack,.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(yk_eventAction(sender:)), for: event)
        
    }
    
    public func yk_titleColor(titleColor: UIColor) -> UIButton {
        self.setTitleColor(titleColor, for: .normal)
        return self
    }
    
    public func yk_titleColorState(titleColor: UIColor,state: UIControl.State) -> UIButton {
        self.setTitleColor(titleColor, for: state)
        return self
    }
    
    public func yk_title(title: String) -> UIButton {
        self.setTitle(title, for: .normal)
        return self
    }
    
    public func yk_titleState(title: String,state: UIControl.State) -> UIButton {
        self.setTitle(title, for: state)
        return self
    }
    
    public func yk_titleFontSize(titleFontSize: CGFloat) -> UIButton {
        self.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize)
        return self
    }
    
    public func yk_image(image: UIImage) -> UIButton {
        self.setImage(image, for: .normal)
        return self
    }
    
    public func yk_imageState(image: UIImage,state: UIControl.State) -> UIButton {
        self.setImage(image, for: state)
        return self
    }
    
    public func yk_backgroundImage(image: UIImage) -> UIButton {
        self.setBackgroundImage(image, for: .normal)
        return self
    }
    
    public func yk_titleInset(titleInset: UIEdgeInsets) -> UIButton {
        self.titleEdgeInsets = titleInset
        return self
    }
    
    public func yk_imageInset(imageInset: UIEdgeInsets) -> UIButton {
        self.imageEdgeInsets = imageInset
        return self
    }
}
