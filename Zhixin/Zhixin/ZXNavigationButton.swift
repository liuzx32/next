//
//  ZXNavigationButton.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/6/4.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXNavigationButton: UIButton {

    override var highlighted: Bool {
        didSet {
            if highlighted {
                backgroundColor = Colors.highlightedNaviColor()
            } else {
                backgroundColor = UIColor.clearColor()
            }
        }
    }

}
