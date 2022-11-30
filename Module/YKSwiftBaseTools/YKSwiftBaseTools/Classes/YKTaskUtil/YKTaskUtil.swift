//
//  YKTaskUtil.swift
//  YK_Swift_BaseTools
//
//  Created by edward on 2021/5/18.
//

import Foundation


public class YKTaskUtil:NSObject
{
    private var tasks = Array<Any>()
    private var currentIndex:NSInteger = 0
    private var saveIndedx:NSInteger = 0
    
    typealias myClosure = () -> Void
    
    /// 开始执行队列
    /// - Returns: 无
    public func executeFirstTask()->Void{
        self.currentIndex = 0
        self.saveIndedx = 0
        nextTask()
    }
    
    /// 执行队列下一个回调
    /// - Returns: 无
    public func nextTask()->Void{
        if (self.currentIndex > self.tasks.count - 1) {
            return
        }
        let task:[String:Any] = self.tasks[self.currentIndex] as! [String : Any]
        let taskClosure:myClosure = task["closure"] as! YKTaskUtil.myClosure
        DispatchQueue.main.async {
            taskClosure()
        }
        self.saveIndedx = self.currentIndex
        self.currentIndex = self.currentIndex + 1
    }
    
    /// 回退执行上一个回调
    /// - Returns: 无
    public func rollbackOneStep()->Void{
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
    public func addClosure(closure: (()->Void)? ,priority:NSInteger)->Void{
        if closure != nil {
            self.tasks.append(["closure":closure as Any , "priority":priority])
            self.tasks.sort { (obj1, obj2) -> Bool in
                let task1 = obj1 as! [String : Any]
                let task2 = obj2 as! [String : Any]
                return (task1["priority"] as! Int) < (task2["priority"] as! Int)
            }
        }else{
            return
        }
    }
    
    /// 执行某个队列中指定的回调
    /// - Parameter priority: 回调优先值
    /// - Returns: 无
    public func executeTask(priority:NSInteger)->Void{
        for obj in self.tasks {
            let task = obj as! [String : Any]
            let pri = task["priority"] as! Int
            if pri == priority {
                let taskClosure:myClosure = task["closure"] as! YKTaskUtil.myClosure
                
                taskClosure()
                return
            }
        }
    }
}
