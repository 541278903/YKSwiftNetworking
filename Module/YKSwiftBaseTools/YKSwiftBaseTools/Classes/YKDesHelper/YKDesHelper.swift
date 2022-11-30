//
//  YKDesHelper.swift
//  YK_Swift_BaseTools
//
//  Created by edward on 2021/5/20.
//

import Foundation
import CommonCrypto


public class YKDesHelper:NSObject
{
    
    /// 加密
    /// - Parameters:
    ///   - message: 明文
    ///   - key: 密钥
    /// - Returns: 密文
    public static func encryptUseDES(message:String, key:String)->String
    {
        
        var _Key:[UInt8] = {
            let key = [UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0)]
            return key
        }()
        var _Iv:[UInt8] = {
            let key = [UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0)]
            return key
        }()
        let str = key.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(key.lengthOfBytes(using: String.Encoding.utf8))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(str!, strLen, result)
        for i in 0..<8 {
            _Key[i] = result[i];
            _Iv[i] = result[i+8]
        }
        var plaintext = ""
        let textData = NSData(data: message.data(using: .utf8) ?? Data.init())
        let dataLength = textData.count
        let bufferSize = size_t(dataLength + kCCBlockSizeDES)
        let buffer = malloc(bufferSize)
        memset(buffer, 0, MemoryLayout<CChar>.size)
        var numBytesDecrypted:size_t = 0
        let cryptStatus = CCCrypt(UInt32(kCCEncrypt), UInt32(kCCAlgorithmDES), UInt32(kCCOptionPKCS7Padding), _Key, kCCKeySizeDES, _Iv, textData.bytes, textData.length , buffer, bufferSize, &numBytesDecrypted)
        
        if cryptStatus == UInt32(kCCSuccess) {
            let plaindata:Data = Data.init(bytes: buffer ?? UnsafeMutableRawPointer.allocate(byteCount: dataLength + kCCBlockSizeDES, alignment: 0), count: Int(numBytesDecrypted))
            plaintext = plaindata.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        }
        free(buffer)
        
        return plaintext
    }
    
    /// 解密
    /// - Parameters:
    ///   - message: 密文
    ///   - key: 密钥
    /// - Returns: 明文
    public static func decryptUseDES(message:String, key:String)->String
    {
        var _Key:[UInt8] = {
            let key = [UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0)]
            return key
        }()
        var _Iv:[UInt8] = {
            let key = [UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0), UInt8(0)]
            return key
        }()
        let str = key.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(key.lengthOfBytes(using: String.Encoding.utf8))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(str!, strLen, result)
        for i in 0..<8 {
            _Key[i] = result[i];
            _Iv[i] = result[i+8]
        }
        //正式解密
        var plaintext = ""
        let cipherdata:NSData = NSData.init(base64Encoded: message, options: NSData.Base64DecodingOptions.init(rawValue: 0)) ?? NSData.init()
        let dataLength = cipherdata.length
        let bufferSize = size_t(dataLength + kCCBlockSizeDES)
        let buffer = malloc(bufferSize)
        memset(buffer, 0, MemoryLayout<CChar>.size)
        var numBytesDecrypted:size_t = 0
        let cryptStatus = CCCrypt(UInt32(kCCDecrypt), UInt32(kCCAlgorithmDES), UInt32(kCCOptionPKCS7Padding), _Key, kCCKeySizeDES, _Iv, cipherdata.bytes, cipherdata.length , buffer, bufferSize, &numBytesDecrypted)
        if cryptStatus == UInt32(kCCSuccess) {
            let plaindata:Data = Data.init(bytes: buffer ?? UnsafeMutableRawPointer.allocate(byteCount: dataLength + kCCBlockSizeDES, alignment: 0), count: Int(numBytesDecrypted))
            plaintext = String.init(data: plaindata, encoding: .utf8) ?? ""
        }
        free(buffer)
        
        return plaintext
    }
    
    public static func setPar(params:String)->String{
        var params = params
        if params.contains("%") {
            params = params.replacingOccurrences(of: "%", with: "%25")
        }
        if params.contains("+") {
            params = params.replacingOccurrences(of: "+", with: "%2B")
        }
        if params.contains(" ") {
            params = params.replacingOccurrences(of: " ", with: "%20")
        }
        if params.contains("/") {
            params = params.replacingOccurrences(of: "/", with: "%2F")
        }
        if params.contains("?") {
            params = params.replacingOccurrences(of: "?", with: "%3F")
        }
        if params.contains("#") {
            params = params.replacingOccurrences(of: "#", with: "%23")
        }
        if params.contains("&") {
            params = params.replacingOccurrences(of: "&", with: "%26")
        }
        if params.contains("=") {
            params = params.replacingOccurrences(of: "=", with: "%3D")
        }
        #if DEBUG
            print("DesHelper-setPar-\(params)")
        #endif
        return params
    }
}
