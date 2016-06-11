//
//  ZXProfileHeadButton.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXProfileHeadButton: UIButton {
    
    override init(frame: CGRect) {
    
        super.init(frame: frame)
        self.setTitle("头像", forState: UIControlState.Normal)
        self.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.backgroundColor = UIColor.whiteColor()
        
        self.imageView?.layer.cornerRadius  = 34;
        self.imageView?.clipsToBounds = true
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = Colors.UIColorFromRGB(0xeceff1).CGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(15, 40, 100, 16)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(self.frame.size.width - 86, 14, 68, 68)
    }

}
