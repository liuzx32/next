//
//  ZXProfileInfoButton.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXProfileInfoButton: UIButton {

    var subLabel : UILabel!
    var sub : String? {
        set(newV) {
            
            if newV?.characters.count == 0 {
                self.subLabel.textAlignment = NSTextAlignment.Right
                self.subLabel.text = "未填写"
            } else {
                self.subLabel.textAlignment = NSTextAlignment.Right
                self.subLabel.text = newV
            }
        }
        
        get {
            return sub
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.subLabel = UILabel(frame: CGRectMake(frame.size.width - 215, 10, 200, frame.size.height - 20))
        self.subLabel.textColor = Colors.UIColorFromRGB(0x777777)
        self.subLabel.textAlignment = NSTextAlignment.Right
        self.subLabel.adjustsFontSizeToFitWidth = true
        self.subLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(self.subLabel)
        
        self.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.backgroundColor = UIColor.whiteColor()
        
        self.titleLabel?.font = UIFont.systemFontOfSize(14)
        
        self.layer.borderColor = Colors.UIColorFromRGB(0xeceff1).CGColor
        self.layer.borderWidth = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(15, 17, 68, 15)
    }
}
