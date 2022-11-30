//
//  YKSectionTableViewCell.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2022/5/26.
//

import UIKit

open class YKSectionTableViewCell: UITableViewCell {
    
    private var _clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)?
    public var clickEvent:((_ eventName:String, _ userInfo:[String:Any]?)->Void)? {
        get {
            return self._clickEvent
        }
    }
    
    internal func toSetClickEvent(eventCallBack:@escaping (_ eventName:String, _ userInfo:[String:Any]?)->Void) {
        self._clickEvent = eventCallBack
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .white
        }
        self.contentView.backgroundColor = .clear
        self.autoExecute()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func autoExecute() {
        
    }
    
    open override class func awakeFromNib() {
        super.awakeFromNib()
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
