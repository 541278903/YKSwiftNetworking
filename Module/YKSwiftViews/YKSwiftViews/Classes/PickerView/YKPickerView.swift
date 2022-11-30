//
//  YKPickerView.swift
//  YKSwiftViews
//
//  Created by edward on 2022/7/3.
//

import UIKit

public protocol YKPickerViewDelegate: NSObjectProtocol {
    
}

class YKPickerView: UIView {
    
    private weak var delegate:YKPickerViewDelegate?

    convenience init(frame:CGRect, delegate:YKPickerViewDelegate? = nil) {
        self.init(frame: frame)
        self.delegate = delegate
    }
 
}

extension YKPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return UIView.init()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString.init(string: "")
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
