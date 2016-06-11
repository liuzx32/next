//
//  ZXProductCommentBar.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/5/14.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXProductCommentBar: UIView {
    
    @IBOutlet var filed : UITextField?
    @IBOutlet var button : UIButton?

    override func awakeFromNib() {
        self.backgroundColor = Colors.UIColorFromRGB(0xf8f8f8)
    }

}
