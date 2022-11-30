//
//  RxCommand.swift
//  YKSwiftExectionModel
//
//  Created by edward on 2021/12/19.
//

import Foundation
import RxSwift


public class RxCommand
{
    private var selfObservable:Observable<Any>? = nil
    init() {
        
    }
    public init(observable:Observable<Any>) {
        selfObservable = observable
    }
    
    public func execute(params:Any?)->Observable<Any> {
        
        
        return selfObservable!
    }
}
