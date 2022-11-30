//
//  YKSwiftNoDataView.swift
//  YKSwiftRefresh
//
//  Created by edward on 2021/11/22.
//

import UIKit

public class YKSwiftNoDataView: UIView
{
    @available(iOSApplicationExtension, unavailable, message: "This is unavailable: Use view controller based solutions where appropriate instead.")
    private init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
