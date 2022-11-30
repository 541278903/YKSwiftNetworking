//
//  UIViewController+YKExectionModel.swift
//  YKSwiftExectionModel
//
//  Created by linghit on 2021/11/18.
//

import UIKit
import Photos
import AVFoundation
import CoreGraphics


extension UIViewController : UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    
    public func yk_showPhotoLibrary(allowEdit: Bool) -> Void {
        let imagePicker = UIImagePickerController.init()
        let attrs = [NSAttributedString.Key.foregroundColor:UIColor.black]
        imagePicker.navigationBar.titleTextAttributes = attrs
        imagePicker.allowsEditing = allowEdit
        imagePicker.delegate = self
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .restricted || status == .denied {
            let msg = KAPPENDAPPNAME("请前往“设置-隐私-照片”选项中，允许%@访问您的手机相册")
            let confirm = UIAlertController.yk_alert(withOKTitle: "提示", message: msg)
            self.present(confirm, animated: true, completion: nil)
            return
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            return
        }
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    public func yk_showCamera(allowEdit: Bool) -> Void {
        let imagePicker = UIImagePickerController.init()
        let attrs = [NSAttributedString.Key.foregroundColor:UIColor.black]
        imagePicker.navigationBar.titleTextAttributes = attrs
        imagePicker.allowsEditing = allowEdit
        imagePicker.delegate = self
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            let msg = KAPPENDAPPNAME("请前往“设置-隐私”选项中，允许%@访问您的摄像头")
            let confirm = UIAlertController.yk_alert(withOKTitle: "提示", message: msg)
            self.present(confirm, animated: true, completion: nil)
            return
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    public func yk_showImagePicker(sourceView: UIView) -> Void {
        yk_showImagePicker(sourceView: sourceView, allowEdit: true)
    }
    
    public func yk_showImagePicker(sourceView: UIView,allowEdit: Bool) -> Void {
        let alertVC = UIAlertController.yk_alertSheet(withTitle: nil, message: nil, titles: ["相册","相机"]) { index in
            if index == 0 {
                self.yk_showPhotoLibrary(allowEdit: allowEdit)
            }else if index == 1 {
                self.yk_showCamera(allowEdit: allowEdit)
            }
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            alertVC.popoverPresentationController?.sourceView = sourceView
            alertVC.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        self.present(alertVC, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image:UIImage? = nil;
        
        #if swift(>=4.2)
        image = info[.editedImage] as? UIImage
            if image == nil {
                image = info[.originalImage] as? UIImage
            }
        #else
            image = info[UIImagePickerControllerEditedImage] as? UIImage
            if image == nil {
                image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
        #endif
        
        if picker.sourceType == .camera {
            if self.responds(to: #selector(yk_getPickerImage(image:))) {
                self.yk_getPickerImage(image: self.fixOrientation(aImage: image))
            }
        }else{
            if self.responds(to: #selector(yk_getPickerImage(image:))) {
                self.yk_getPickerImage(image: image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image:UIImage? = nil;
        
        #if swift(>=4.2)
            image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage
            if image == nil {
                image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
            }
        #else
            image = info[UIImagePickerControllerEditedImage] as? UIImage
            if image == nil {
                image = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
        #endif
        
        if picker.sourceType == .camera {
            if self.responds(to: #selector(yk_getPickerImage(image:))) {
                self.yk_getPickerImage(image: self.fixOrientation(aImage: image))
            }
        }else{
            if self.responds(to: #selector(yk_getPickerImage(image:))) {
                self.yk_getPickerImage(image: image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func fixOrientation(aImage: UIImage?) -> UIImage? {
        guard let bImage = aImage else{
            return nil
        }
        if bImage.imageOrientation == .up {
            return bImage
        }
        var transform = CGAffineTransform.identity
        
        switch bImage.imageOrientation{
            case .up:
                break
            case .down:
            transform = transform.translatedBy(x: bImage.size.width, y: bImage.size.height)
            transform = transform.rotated(by: CGFloat.pi)
                break
            case .left:
            transform = transform.translatedBy(x: bImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
                break
            case .right:
            transform = transform.translatedBy(x: 0, y: bImage.size.height)
            transform = transform.rotated(by: -(CGFloat.pi/2))
                break
            case .upMirrored:
                break
            case .downMirrored:
            transform = transform.translatedBy(x: bImage.size.width, y: bImage.size.height)
            transform = transform.rotated(by: CGFloat.pi)
                break
            case .leftMirrored:
            
            transform = transform.translatedBy(x: bImage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
                break
            case .rightMirrored:
            transform = transform.translatedBy(x: 0, y: bImage.size.height)
            transform = transform.rotated(by: -(CGFloat.pi/2))
                break
            @unknown default:
                break
        }
        
        
        guard let ctx = CGContext.init(data: nil, width: Int(bImage.size.width), height: Int(bImage.size.height), bitsPerComponent: bImage.cgImage!.bitsPerComponent, bytesPerRow: 0, space: bImage.cgImage!.colorSpace!, bitmapInfo: bImage.cgImage!.bitmapInfo.rawValue) else {
            return nil
        }
        
        ctx.concatenate(transform)
        switch bImage.imageOrientation{
            case .up:
                break
            case .down:
                break
            case .upMirrored:
                break
            case .downMirrored:
                break
            case .left:
                break
            case .leftMirrored:
                break
        case .right:
            ctx.draw(bImage.cgImage!, in: CGRect(x: 0, y: 0, width: bImage.size.height, height: bImage.size.width))
                break
        case .rightMirrored:
            ctx.draw(bImage.cgImage!, in: CGRect(x: 0, y: 0, width: bImage.size.width, height: bImage.size.height))
                break
            @unknown default:
                break
        }
        guard let cgimg = ctx.makeImage() else {
            return nil
        }
        let img = UIImage.init(cgImage: cgimg)
        return img
    }
    
    @objc open func yk_getPickerImage(image: UIImage?) -> Void {
        
    }
}
