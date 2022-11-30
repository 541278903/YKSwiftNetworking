//
//  UIImage+Core.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/5/20.
//

import Foundation
import UIKit


extension UIImage
{
    public static func yk_moduleImage(bundleName: String, className: String, imageNamed: String) -> UIImage {
        if ((imageNamed != "")) {
            let bundle = Bundle(for: NSClassFromString(className) ?? NSObject.self)
            let url = bundle.url(forResource: bundleName, withExtension: "bundle")
            if url == nil {
                let image = UIImage.init(named: imageNamed)
                return image ?? UIImage.init()
            }
            var imagename = ""
            let imageBundle = Bundle.init(url: url!)
            let scale = UIScreen.main.scale
            if ((abs(scale - 3)) <= 0.001) {
                imagename = "\(imageNamed)@3x"
            }else if ((abs(scale - 2)) <= 0.01){
                imagename = "\(imageNamed)@2x"
            }else{
                imagename = imageNamed
            }
            let image = UIImage.init(contentsOfFile: imageBundle?.path(forResource: imagename, ofType: "png") ?? "imageNamed") ?? UIImage.init()
            return image
            
        }else{
            return UIImage.init()
        }
    }
    
    public static func yk_moduleXcassetImage(bundleName: String, className: String, imageNamed: String) -> UIImage {
        if ((imageNamed != "")) {
            let bundle = Bundle(for: NSClassFromString(className) ?? NSObject.self)
            let url = bundle.url(forResource: bundleName, withExtension: "bundle")
            if url == nil {
                let image = UIImage.init(named: imageNamed)
                return image ?? UIImage.init()
            }
            let imageBundle = Bundle.init(url: url!)
            let image = UIImage.init(named: imageNamed, in: imageBundle, compatibleWith: nil) ?? UIImage.init()
            return image
        }else{
            return UIImage.init()
        }
    }
    
    public func yk_compressToJPEGData(maxLength max:Int, eachQuality quality:CGFloat = 0.1) -> Data? {
        let resultImage = self
        var rate:CGFloat = 1
        if var data = resultImage.jpegData(compressionQuality: rate) {
            while data.count > max {
                if let subData = resultImage.jpegData(compressionQuality: rate) {
                    data = subData
                }
                if quality < 1 && quality > 0 {
                    
                    rate = rate - quality
                }else {
                    
                    rate = rate - 0.1
                }
                if (rate <= 0) {
                    break;
                }
            }
            return data
        }else {
            return nil
        }
    }
}
