//
//  UIView+Core.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/18.
//

import Foundation
import UIKit

extension UIView {
    
    private struct AssociatedKey {
        static var taponViewCallBack: String = "taponViewCallBack"
        static var longTaponViewCallBack: String = "longTaponViewCallBack"
        static var yk_makeViewDragableInParams: String = "yk_makeViewDragableInParams"
        static var yk_makeViewDragableInparentView: String = "yk_makeViewDragableInparentView"
        static var yk_makeViewDragableInlastXInset:String = "yk_makeViewDragableInlastXInset"
    }
    
    public enum YKShadowPathType {
        case Top
        case Bottom
        case Left
        case Right
        case Common
        case Around
    }
    
    public var centerX:CGFloat {
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get{
            return self.center.x
        }
    }
    
    public var centerY:CGFloat {
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get{
            return self.center.y
        }
    }
    
    public var size:CGSize {
        set{
            var farm = self.frame
            farm.size = newValue
            self.frame = farm
        }
        get{
            return self.frame.size
        }
    }
    
    public var x:CGFloat {
        set{
            var farm = self.frame
            farm.origin.x = newValue
            self.frame = farm
        }
        get{
            return self.frame.origin.x
        }
    }
    
    public var maxX:CGFloat {
        set{
            var frame = self.frame;
            frame.origin.x = newValue - frame.size.width;
            self.frame = frame;
        }
        get{
            return self.frame.maxX
        }
    }
    
    public var y:CGFloat {
        set{
            var farm = self.frame
            farm.origin.y = newValue
            self.frame = farm
        }
        get{
            return self.frame.origin.y
        }
    }
    
    public var maxY:CGFloat {
        set{
            var frame = self.frame;
            frame.origin.y = newValue - frame.size.height;
            self.frame = frame;
        }
        get{
            return self.frame.maxY
        }
    }
    
    public var width:CGFloat {
        set{
            var farm = self.frame
            farm.size.width = newValue
            self.frame = farm
        }
        get{
            return self.frame.size.width
        }
    }
    
    public var height:CGFloat {
        set{
            var farm = self.frame
            farm.size.height = newValue
            self.frame = farm
        }
        get{
            return self.frame.size.height
        }
    }
    
    public func instance() -> UIView {
        return self;
    }
    
    public func yk_x(_ x: CGFloat) -> UIView {
        self.x = x
        return self
    }
    
    public func yk_y(_ y: CGFloat) -> UIView {
        self.y = y
        return self
    }
    
    public func yk_maxX(_ maxX: CGFloat) -> UIView {
        self.maxX = maxX;
        return self
    }
    
    public func yk_maxY(_ maxY: CGFloat) -> UIView {
        self.maxY = maxY;
        return self
    }
    
    public func yk_centerX(_ centerX: CGFloat) -> UIView {
        self.centerX = centerX
        return self
    }
    
    public func yk_centerY(_ centerY: CGFloat) -> UIView {
        self.centerY = centerY
        return self
    }
    
    public func yk_width(_ width: CGFloat) -> UIView {
        self.width = width
        return self
    }
    
    public func yk_height(_ height: CGFloat) -> UIView {
        self.height = height
        return self
    }
    
    public func yk_backgroundColor(_ color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }
    
    public func yk_frame(_ frame: CGRect) -> UIView {
        self.frame = frame
        return self
    }
    
    public func yk_raduis(_ raduis: CGFloat) -> UIView {
        self.layer.cornerRadius = raduis
        return self
    }
    
    public func yk_borderColor(_ color: UIColor) -> UIView {
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
        return self
    }
    
    public func yk_sizeToFit() -> UIView {
        self.sizeToFit()
        return self
    }
    
    public func yk_clipToBounds() -> UIView {
        self.clipsToBounds = true
        return self
    }
    
    public func yk_addTo(_ view: UIView) -> UIView {
        view.addSubview(self)
        return self
    }
    
    public func yk_duplicate() -> UIView {
        let tempArchive = NSKeyedArchiver.archivedData(withRootObject: self)
        return NSKeyedUnarchiver.unarchiveObject(with: tempArchive) as! UIView
    }
    
    public func yk_addShadowToView() -> Void {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.12//阴影透明度，默认0
        self.layer.shadowRadius = 8//阴影半径，默认3
        self.layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
    }
    
    public func yk_addShadowToView(color: UIColor, offset: CGSize) -> Void {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor//shadowColor阴影颜色
        self.layer.shadowOffset = offset//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5//阴影透明度，默认0
        self.layer.shadowRadius = 3//阴影半径，默认3
        self.layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
    }
    
    public func yk_addShadowToView(color: UIColor, offset: CGSize, size: CGFloat) -> Void {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor//shadowColor阴影颜色
        self.layer.shadowOffset = offset//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5//阴影透明度，默认0
        if size == 0 {
            self.layer.shadowRadius = 3//阴影半径，默认3
        }else{
            self.layer.shadowRadius = size
        }
        self.layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
    }
    
    public func yk_addShadowToView(color: UIColor, offset: CGSize, opacity: CGFloat, radius: CGFloat) -> Void {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor//shadowColor阴影颜色
        self.layer.shadowOffset = offset//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = Float(opacity)//阴影透明度，默认0
        if radius == 0 {
            self.layer.shadowRadius = 3//阴影半径，默认3
        }else{
            self.layer.shadowRadius = radius
        }
        self.layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
    }
    
    public func yk_addShadowToView(color: UIColor, offset: CGSize, opacity: CGFloat, radius: CGFloat, layerRaduis: CGFloat) -> Void {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor//shadowColor阴影颜色
        self.layer.shadowOffset = offset//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = Float(opacity)//阴影透明度，默认0
        if radius == 0 {
            self.layer.shadowRadius = 3//阴影半径，默认3
        }else{
            self.layer.shadowRadius = radius
        }
        self.layer.shadowPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: layerRaduis).cgPath
    }
    
    public func yk_viewShadowPath(shadowColor: UIColor, shadowOpacity: CGFloat, shadowRadius: CGFloat, shadowPathType: YKShadowPathType, shadowPathWidth: CGFloat) {
        self.layer.masksToBounds = false//必须要等于NO否则会把阴影切割隐藏掉
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = shadowRadius
        var shadowRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let originX:CGFloat = 0
        let originY:CGFloat = 0
        let sizeWidth = self.bounds.size.width
        let sizeHeight = self.bounds.size.height
        
        if shadowPathType == .Top {
            shadowRect = CGRect(x: originX, y: originY-shadowPathWidth/2, width: sizeWidth, height: shadowPathWidth)
        }else if (shadowPathType == .Bottom){
            shadowRect = CGRect(x: originY
                                , y: sizeHeight - shadowPathWidth/2, width: sizeWidth, height: shadowPathWidth)
        }else if (shadowPathType == .Left){
            shadowRect = CGRect(x: originX - shadowPathWidth/2, y: originY, width: shadowPathWidth, height: sizeHeight)
        }else if (shadowPathType == .Right){
            shadowRect = CGRect(x: sizeWidth-shadowPathWidth/2, y: originY, width: shadowPathWidth, height: sizeHeight)
        }else if (shadowPathType == .Common){
            shadowRect = CGRect(x: originX-shadowPathWidth/2, y: 2, width: sizeWidth+shadowPathWidth, height: sizeHeight+shadowPathWidth/2)
        }else if (shadowPathType == .Around){
            shadowRect = CGRect(x: originX-shadowPathWidth/2, y: originY-shadowPathWidth/2, width: sizeWidth+shadowPathWidth, height: sizeHeight+shadowPathWidth)
        }
        let bezierPath = UIBezierPath.init(rect: shadowRect)
        self.layer.shadowPath = bezierPath.cgPath//阴影路径
        
    }
    
    public func yk_addBlurEffect(withStyle style: UIBlurEffect.Style) -> Void {
        let blurEffect:UIVisualEffect = UIBlurEffect.init(style: style)
        let visualEffectView:UIVisualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = self.bounds
        self.addSubview(visualEffectView)
    }
    
    public func yk_addRadius(radius: CGFloat, corners: UIRectCorner) -> Void {
        //设置切哪个直角
        //    UIRectCornerTopLeft     = 1 << 0,  左上角
        //    UIRectCornerTopRight    = 1 << 1,  右上角
        //    UIRectCornerBottomLeft  = 1 << 2,  左下角
        //    UIRectCornerBottomRight = 1 << 3,  右下角
        //    UIRectCornerAllCorners  = ~0UL     全部角
        //得到view的遮罩路径
        let maskPath:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        //创建 layer
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        //赋值
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
    }
    
    public func yk_addCorner(corners: UIRectCorner, cacorners: CACornerMask, radius: CGFloat) -> Void {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cacorners
        } else {
            let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer.init()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    public func yk_addCorner(corners: UIRectCorner, cacorners: CACornerMask, radius: CGFloat, borderColor: UIColor) -> Void {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cacorners
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1
        } else {
            let mask:CAShapeLayer = CAShapeLayer.init()
            let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            mask.path = path.cgPath
            mask.frame = self.bounds
            let borderLayer:CAShapeLayer = CAShapeLayer.init()
            borderLayer.path = path.cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = 1
            borderLayer.frame = self.bounds
            self.layer.mask = mask
            self.layer.addSublayer(borderLayer)
        }
    }
    
    public func yk_addGradientLayer(beginColor: UIColor, endColor: UIColor, cornerRadius: CGFloat) -> Void {
        let gradient = CAGradientLayer.init()
        gradient.frame = self.bounds
        gradient.colors = [beginColor.cgColor,endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func yk_addVerticalGradientLayer(beginColor: UIColor, endColor: UIColor, cornerRadius: CGFloat) -> Void {
        let gradient = CAGradientLayer.init()
        gradient.frame = self.bounds
        gradient.colors = [beginColor.cgColor,endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func yk_addCorner(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> Void {
        if cornerRadius != 0 {
            self.layer.cornerRadius = cornerRadius
        }
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    public func yk_intersect(view: UIView) -> Bool {
        let window:UIWindow = UIApplication.shared.keyWindow ?? UIWindow.init()
        let selfRect:CGRect = self.convert(self.bounds, to: window)
        let viewRect:CGRect = view.convert(view.bounds, to: window)
        return selfRect.intersects(viewRect)
    }
    
    public func yk_snapshotView(afterUpdates updates: Bool) -> UIView {
        if Float(UIDevice.current.systemVersion) ?? 9.0>=10.0 {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0.0)
            let context = UIGraphicsGetCurrentContext()!
            self.layer.render(in: context)
            let targetImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let snapView = UIImageView.init(image: targetImage)
            snapView.frame = self.frame
            return snapView
        }else{
            return self.snapshotView(afterScreenUpdates: updates) ?? UIView.init()
        }
    }
    
    private var taponViewCallBack:((_ tap:UITapGestureRecognizer)->Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.taponViewCallBack) as? ((_ tap:UITapGestureRecognizer)->Void)
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.taponViewCallBack, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func yk_tapOnView(tapCallback: @escaping (_ tap:UITapGestureRecognizer) -> Void) -> Void {
        self.isUserInteractionEnabled = true
        self.taponViewCallBack = tapCallback
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(yk_tapAction(tap:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func yk_tapAction(tap: UITapGestureRecognizer) -> Void {
        if self.taponViewCallBack != nil {
            self.taponViewCallBack!(tap);
        }
    }
    
    private var longTaponViewCallBack: ((_ tap:UILongPressGestureRecognizer) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.longTaponViewCallBack) as? (_ tap:UILongPressGestureRecognizer)->Void
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.longTaponViewCallBack, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func yk_longPress(second: Int, tapCallback: @escaping (_ tap: UILongPressGestureRecognizer) -> Void) -> Void {
        self.longTaponViewCallBack = tapCallback;
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(yk_longtapAction(tap:)))
        longPress.minimumPressDuration = TimeInterval(second)
        self.addGestureRecognizer(longPress)
    }
    
    @objc private func yk_longtapAction(tap: UILongPressGestureRecognizer) -> Void {
        if self.longTaponViewCallBack != nil {
            self.longTaponViewCallBack!(tap);
        }
    }
    
    public static func defaultIdentifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    public static func defaultNib() -> UINib {
        return UINib.init(nibName: UIView.defaultIdentifier(), bundle: Bundle.init(for: self.classForCoder()))
    }
    
    public func yk_screenshot(croppingRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(croppingRect.size, false, UIScreen.main.scale)
        // Create a graphics context and translate it the view we want to crop so
        // that even in grabbing (0,0), that origin point now represents the actual
        // cropping origin desired:
        let context = UIGraphicsGetCurrentContext()
        if context == nil {
            return nil
        }
        context!.translateBy(x: -croppingRect.origin.x, y: -croppingRect.origin.y)
        self.layoutIfNeeded()
        self.layer.render(in: context!)
        
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }
    
    @objc private func yk_makeViewDragableCallBack(pan: UIPanGestureRecognizer) -> Void {
        
        guard let parentView = objc_getAssociatedObject(self,&AssociatedKey.yk_makeViewDragableInParams) as? UIView else { return }
        let point = pan.location(in: parentView)
        if pan.state == UIGestureRecognizer.State.ended || pan.state == UIGestureRecognizer.State.cancelled || pan.state == UIGestureRecognizer.State.failed{
            if pan.view?.center.x ?? 0 < UIScreen.main.bounds.size.width/2 {
                pan.view?.x = 0
            }else if (pan.view?.center.x ?? 0 >= (UIScreen.main.bounds.size.width/2) && pan.view?.center.x ?? 0 <= UIScreen.main.bounds.size.width){
                pan.view?.x = UIScreen.main.bounds.width - (pan.view?.width ?? 0);
            }
        }else{
            pan.view?.center = point
        }
    }
    
    public func yk_makeViewDragable(parentView: UIView) -> Void {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(yk_makeViewDragableCallBack(pan:)))
        objc_setAssociatedObject(pan,&AssociatedKey.yk_makeViewDragableInParams,parentView,.OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addGestureRecognizer(pan)
    }
    
    @objc private func yk_makeViewDragableInCallBack(pan: UIPanGestureRecognizer) -> Void {
        guard let parentView = objc_getAssociatedObject(self,&AssociatedKey.yk_makeViewDragableInparentView) as? UIView else { return }
        guard let lastXInset = objc_getAssociatedObject(self,&AssociatedKey.yk_makeViewDragableInlastXInset) as? CGFloat else { return }
        
        let point = pan.location(in: parentView)
        
        let screenW = UIScreen.main.bounds.size.width
        if pan.state == UIGestureRecognizer.State.ended || pan.state == UIGestureRecognizer.State.cancelled || pan.state == UIGestureRecognizer.State.failed{
            if (pan.view?.center.x ?? 0 < (screenW/2)) {
                pan.view?.x = 0 - lastXInset
            }else if (pan.view?.center.x ?? 0 >= (screenW/2) && pan.view?.center.x ?? 0 <= screenW){
                pan.view?.x = screenW - (pan.view?.width ?? 0) + lastXInset;
            }
            if (pan.view?.maxY ?? 0 > (YKScreenH - KTabBar_HEIGHT)) {
                pan.view?.y = YKScreenH - KTabBar_HEIGHT - (pan.view?.height ?? 0) - 20;
            }else if (pan.view?.y ?? 0 < 100){
                pan.view?.y = 100;
            }
        }else{
            pan.view?.center = point
        }
    }
    
    public func yk_makeViewDragableIn(parentView: UIView, lastXInset: CGFloat) -> Void {
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(yk_makeViewDragableInCallBack(pan:)))
        
        objc_setAssociatedObject(pan,&AssociatedKey.yk_makeViewDragableInparentView,parentView,.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(pan,&AssociatedKey.yk_makeViewDragableInlastXInset,lastXInset,.OBJC_ASSOCIATION_COPY_NONATOMIC)
        
        self.addGestureRecognizer(pan)
    }
    
    public func yk_drawLine(lineLength: Int, lineSpacing: Int, lineColor: UIColor, isHorizonal: Bool) -> Void {
        let lineView = self
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.bounds = lineView.bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        if isHorizonal {
            shapeLayer.position = CGPoint(x: lineView.width/2, y: lineView.height)
            shapeLayer.lineWidth = lineView.height
            path.addLine(to: CGPoint(x: lineView.width, y: 0))
        }else{
            shapeLayer.position = CGPoint(x: lineView.width/2, y: lineView.height/2)
            shapeLayer.lineWidth = lineView.width
            path.addLine(to: CGPoint(x: 0, y: lineView.height))
        }
        
        
        #if swift(>=4.2)
            shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        #else
            shapeLayer.lineJoin = kCALineJoinRound
        #endif
        
        shapeLayer.lineDashPattern = [NSNumber(integerLiteral: lineLength),NSNumber(integerLiteral: lineSpacing)]
        
        shapeLayer.path = path
        
        lineView.layer.addSublayer(shapeLayer)
    }
    
    public func yk_addCurve(points: Array<CGPoint>, lineColor: UIColor, fillColor: UIColor, isClosePath: Bool, lineWidth: CGFloat) -> Void {
        let shapelayerPath = UIBezierPath.init()
        shapelayerPath.lineWidth = lineWidth
        
        for (i,item) in points.enumerated() {
            if i == 0 {
                shapelayerPath.move(to: item)
            }else {
                shapelayerPath.addLine(to: item)
            }
        }
        
        if isClosePath {
            shapelayerPath.close()
        }
        
        let shapelayer = CAShapeLayer.init()
        shapelayer.path = shapelayerPath.cgPath
        shapelayer.fillColor = fillColor.cgColor
        shapelayer.strokeColor = lineColor.cgColor
        self.layer.addSublayer(shapelayer)
        
    }
    
}
