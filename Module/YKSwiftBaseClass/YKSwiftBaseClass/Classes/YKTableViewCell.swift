//
//  YKTableViewCell.swift
//  YKSwiftBaseClass
//
//  Created by linghit on 2021/11/17.
//

import UIKit

open class YKTableViewCell: UITableViewCell {
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .white
        }
        self.contentView.backgroundColor = .clear
        autoExecute()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var handleBlock:((_ eventName:String, _ userInfo:[String:Any]) -> Void)? = nil
    
    open func autoExecute() {
        
    }
    
    open func didSetupUI(view: UIView) -> Void {
        
    }
    
    open func didBindData() -> Void {
        
    }
    
    open func configData(viewModel:YKViewModel, indexPath:IndexPath, dataSource:[Any]) -> Void{
        
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .white
        }
        self.contentView.backgroundColor = .clear
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
