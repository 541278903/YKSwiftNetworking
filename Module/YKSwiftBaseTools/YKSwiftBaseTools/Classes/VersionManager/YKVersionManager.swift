//
//  YKVersionManager.swift
//  YKSwiftBaseTools
//
//  Created by linghit on 2021/10/21.
//

import UIKit
import Foundation

public class YKVersionManager: NSObject {
    
    public static func checkVersion(targetVersion target:String, localVersion local:String? = nil, complete:((_ status:ComparisonResult)->Void)) -> Void {
        
        var localVersion = ""
        if local != nil {
            localVersion = local!
        }else {
            if let CGBundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
                localVersion = "\(CGBundleVersion)"
            }else {
                localVersion = "0.0.0"
            }
        }
        
        let version1Arr = target.components(separatedBy: ".")
        let version2Arr = localVersion.components(separatedBy: ".")
        let v1Count = version1Arr.count
        let v2Count = version2Arr.count
        
        let maxCount = (v1Count < v2Count) ? v2Count : v1Count
        var result:ComparisonResult = .orderedSame
        
        for i in 0..<maxCount {
            let value1 = (i < v1Count) ? Int(version1Arr[i]) : 0
            let value2 = (i < v2Count) ? Int(version2Arr[i]) : 0
            
            if let v1 = value1,
               let v2 = value2
            {
                if v1 < v2 {
                    result = .orderedAscending
                    break
                }
                
                if v1 > v2 {
                    result = .orderedDescending
                    break
                }
            }
        }
        complete(result)
        
    }
    
}
