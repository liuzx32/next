//
//  ZXDateHeaderView.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/5/8.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXDateHeaderView: UIView {

    var dateLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.dateLabel = UILabel(frame: CGRectMake(20, 0, 320, 35))
        self.addSubview(self.dateLabel!)
        self.dateLabel?.textColor = Colors.UIColorFromRGB(0x333333)
        self.backgroundColor = Colors.UIColorFromRGB(0xe2e2e2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
