//
//  ZXShareView.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

protocol ShareViewDelegate {
    func shareDidCancel()
    func shareViewDidChoose(type: ShareType)
}

class ZXShareView: UIView {

    var titleLabel : UILabel!
    var confirmButton : UIButton!
    var delegate : ShareViewDelegate?

    override init(frame: CGRect) {
        
        
        
        self.titleLabel = UILabel.init(frame: CGRectMake(0,frame.size.height - 300 + 15, frame.size.width, 15));
        self.titleLabel.text = "分享到"
        self.titleLabel.backgroundColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = NSTextAlignment.Center

        self.confirmButton = UIButton.init(frame: CGRectMake(20,frame.size.height - 300 + 235, frame.size.width - 40, 44))
        self.confirmButton.setTitle("取消", forState: UIControlState.Normal)
        self.confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.confirmButton.backgroundColor = Colors.navigationColor()
        
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0, green: 0, blue:0 , alpha: 0.3)
        
        let bav = UIView(frame: CGRectMake(0, frame.size.height - 300, frame.size.width, 500))
        bav.backgroundColor = UIColor.whiteColor()
        self.addSubview(bav)
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.confirmButton)
        self.confirmButton.addTarget(self, action: #selector(ZXShareView.confirmButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.confirmButton.layer.cornerRadius = 4
        self.confirmButton.clipsToBounds = true
    
        let topM : Float32 = 35
        
        for index in 0...5 {
            
            print("the i is \(index)")
            
            var button = ZXShareButton(frame: CGRectMake(CGFloat(index % 3) * (frame.size.width / 3.0), CGFloat(topM) + CGFloat(index / 3) * 90 + frame.size.height - 300, frame.size.width / 3.0, 90))
            button.tag = index + 1
            self.addSubview(button)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
            button.addTarget(self, action: #selector(ZXShareView.shareButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            switch index {
            case 1:
                button.shareType = ShareType.ShareTypeWeibo
                break
            case 2:
                button.shareType = ShareType.ShareTypeQQZone
                break
            case 0:
                 button.shareType = ShareType.ShareTypeWeChat
                break
            case 3:
                button.shareType = ShareType.ShareTypePengyouquan
                break
            case 4:
                button.shareType = ShareType.ShareTypeCopy
                break
            case 5:
                button.shareType = ShareType.ShareTypeQQ
                break
            default:
                break
            }
        }
        
        self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, frame.size.width, frame.size.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confirmButtonPressed(sender : AnyObject) {
//        self.delegate?.shareDidCancel()
        self.hide()
    }
    
    func show() {
        
        var rect = self.frame
        rect.origin.y = 0
        
        UIView.animateWithDuration(0.2) { 
            self.frame = rect
        }
    }
    
    func hide() {
        self.removeFromSuperview()
    }
    
    func shareButtonPressed(sender : AnyObject) {
        
        var type : ShareType = ShareType.ShareTypeWeChat
        
        if sender.tag == 1 {
            type = ShareType.ShareTypeWeChat
        }
        
        self.delegate?.shareViewDidChoose(type)
    }
}
