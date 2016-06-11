//
//  ZXDateHeaderView.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/5/8.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

protocol ZXDateHeaderViewDelegate {
    
    func dateHeaderViewDidPressMoreButton(view: ZXDateHeaderView)
}

class ZXDateHeaderView: UIView {

    var dateLabel : UILabel?
    var dtextLabel : UILabel?
    var indexPath : Int?
    var moreButton : UIButton?
    var delegate : ZXDateHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.dtextLabel = UILabel(frame: CGRectMake(20, 0, 320, 35))
        self.dtextLabel?.font = UIFont.boldSystemFontOfSize(18)
        self.dtextLabel?.textColor = Colors.UIColorFromRGB(0x333333)
        self.addSubview(self.dtextLabel!)
        
        self.dateLabel = UILabel(frame: CGRectMake(80, 0, 320, 35))
        self.addSubview(self.dateLabel!)
        self.dateLabel?.textColor = Colors.UIColorFromRGB(0x333333)
        self.backgroundColor = Colors.UIColorFromRGB(0xe2e2e2)
        self.dateLabel?.font = UIFont.systemFontOfSize(15)
        
        self.moreButton = UIButton(frame: CGRectMake(self.frame.size.width - 60, 0, 50, self.frame.size.height))
        self.moreButton?.setTitle("更多 >", forState: UIControlState.Normal)
        self.moreButton?.setTitleColor(Colors.navigationColor(), forState: UIControlState.Normal)
        self.moreButton?.addTarget(self, action: #selector(ZXDateHeaderView.favoButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.moreButton?.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.addSubview(self.moreButton!);
    }
    
    func favoButtonPressed(sender : AnyObject) {
        
        if self.delegate != nil {
            self.delegate?.dateHeaderViewDidPressMoreButton(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
