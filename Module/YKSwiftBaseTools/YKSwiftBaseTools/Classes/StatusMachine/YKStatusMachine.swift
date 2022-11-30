//
//  YKStatusMachine.swift
//  YKSwiftBaseTools
//
//  Created by edward on 2021/10/21.
//

import Foundation

public class YKStatusMachine: NSObject {
    
    private var currentStateName:String = ""
    
    private lazy var states:[String:YKStatusMachineProtrocol] = {
        var states:[String:YKStatusMachineProtrocol] = [:]
        return states
    }();
    
    public static func stateMachine(states:[String:YKStatusMachineProtrocol]) -> YKStatusMachine {
        let statusMachine = YKStatusMachine.init()
        for (key,value) in states {
            statusMachine.states.updateValue(value, forKey: key)
            statusMachine.currentStateName = ""
        }
        return statusMachine;
    }
    
    public func canEnterState(stateName:String) -> Bool {
        return states.keys.contains(stateName)
    }
    
    @discardableResult
    public func enter(stateName:String, container:YKStatusMachineContainerProtrocol) -> Bool {
        var currentState:YKStatusMachineProtrocol? = nil;
        if self.currentStateName.count != 0 {
            currentState = self.states[self.currentStateName]
        }
        
        if stateName == self.currentStateName {
            return false;
        }
        
        if self.canEnterState(stateName: stateName) {
            currentState?.yk_statusMachine(self, willExit: stateName)
            
            let nextState = self.states[stateName]
            nextState?.yk_statusMachine(self, previousState: self.currentStateName, enterToContainer: container)
            self.currentStateName = stateName
            return true
        }else{
            return false
        }
    }
    
    public func getCurrentStateName() -> String {
        return self.currentStateName
    }
}
