//
//  YKTaskUtil.swift
//  YK_Swift_BaseTools
//
//  Created by edward on 2021/5/18.
//

import Foundation


public class YKTaskUtil:NSObject
{
    private var tasks:[[String:Any]] = []
    private var currentIndex:Int = 0
    private var saveIndedx:Int = 0
    
    typealias myClosure = () -> Void
    
    /// 开始执行队列
    /// - Returns: 无
    public func executeFirstTask() -> Void {
        self.currentIndex = 0
        self.saveIndedx = 0
        self.nextTask()
    }
    
    /// 执行队列下一个回调
    /// - Returns: 无
    public func nextTask() -> Void {
        if (self.currentIndex > self.tasks.count - 1) {
            return
        }
        if let taskClosure = self.tasks[self.currentIndex]["closure"] as? YKTaskUtil.myClosure {
            DispatchQueue.main.async {
                taskClosure()
            }
            self.saveIndedx = self.currentIndex
            self.currentIndex = self.currentIndex + 1
        }
           
    }
    
    /// 回退执行上一个回调
    /// - Returns: 无
    public func rollbackOneStep() ->Void {
        if (self.currentIndex <= 0) {
            return
        }
        self.currentIndex = self.saveIndedx
    }
    
    /// 往队列中添加回调
    /// - Parameters:
    ///   - closure: 回调
    ///   - priority: 优先值
    /// - Returns: 无
    public func addClosure(closure: (()->Void)? ,of priority:Int) -> Void{
        if closure != nil {
            self.tasks.append(["closure":closure! , "priority":priority])
            self.tasks.sort { (obj1, obj2) -> Bool in
                if let pri1 = obj1["priority"] as? Int,
                   let pri2 = obj2["priority"] as? Int
                {
                     return pri1 > pri2
                }else {
                    return true
                }
            }
        }else{
            return
        }
    }
    
    /// 执行某个队列中指定的回调
    /// - Parameter priority: 回调优先值
    /// - Returns: 无
    public func executeTask(of priority:Int) -> Void{
        for obj in self.tasks {
            if let pri = obj["priority"] as? Int,
               pri == priority,
               let taskClosure:myClosure = obj["closure"] as? YKTaskUtil.myClosure
            {
                taskClosure()
            }
        }
    }
}
