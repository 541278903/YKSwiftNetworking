//
//  YKSwiftRecordUtil.swift
//  YKSwiftBaseTools
//
//  Created by linghit on 2021/12/7.
//

import UIKit
import Foundation
import AVFoundation

@objc public enum YKSwiftRecordQuality:Int {
    case Low = 0
    case Normal = 1
    case High = 2
    case VeryHigh = 3
}

@objc public protocol YKSwiftRecordUtilDelegate : NSObjectProtocol {
    
    
    /// 编码失败
    /// - Returns: 无
    func recordEncode(error:Error) -> Void
    
    /// 录音成功
    /// - Returns: 无
    func recordSuccess(url:URL, duration:TimeInterval) -> Void
    
    /// 音量变化
    /// - Returns: 无
    @objc optional func recordVolumePercentDidChange(percent:Float) -> Void
    
}

public protocol YKSwiftRecordUtilConflictDelegate : NSObjectProtocol {
    
    /// 录音开始调用，此处需要暂停其他的音频播放和录音事件
    /// - Returns: 是否能够录音
    func recordUtil(_ recordUtil:YKSwiftRecordUtil, _ handleConflictIfNeed:((_ complete:Bool) -> Void)) -> Bool
    
    /// 录音结束
    /// - Returns: 无
    func recordUtil(_ recordUtil:YKSwiftRecordUtil, _ recordDidfinish:Bool) -> Void
}

public class YKSwiftRecordUtil: NSObject {
    
    public static let shared = YKSwiftRecordUtil()
    
    public var delegate:YKSwiftRecordUtilDelegate?
    
    public var conflictDelegate:YKSwiftRecordUtilConflictDelegate?
    
    public var recodingPath:URL?
    
    public var voiceSize:TimeInterval = 0
    
    public var currentQuality:YKSwiftRecordQuality?
    
    private let kDefaultQualityKey = "kDefaultQualityKey"
    
    private var _isHandling:Bool = false
    
    private var _isCancel:Bool = false
    
    private var recorder:AVAudioRecorder? = nil
    
    private var timer:Timer? = nil
    
    
    override private init() {
        super.init()
        
    }
    
    public func start() -> Bool {
        return start(with: .Low, directory: "")
    }
    
    public func start(with quailty:YKSwiftRecordQuality, directory:String) -> Bool {
        return true
    }
    
    public func saveDefaultQuailty(quailty:YKSwiftRecordQuality) -> Void {
        
    }
    
    public func prepareForRecord() -> Bool {
        return false
    }
    
    public func cancel() -> Void {
        
    }
    
    public func stop() -> Void {
        
    }
    
    public func pause() -> Void {
        
    }
    
    public func resume() -> Void {
        
    }
}
