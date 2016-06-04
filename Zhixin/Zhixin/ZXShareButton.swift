//
//  ZXShareButton.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

enum ShareType {
    case ShareTypeWeChat
    case ShareTypeWeibo
    case ShareTypeQQZone
    case ShareTypePengyouquan
    case ShareTypeCopy
    case ShareTypeQQ
}

class ZXShareButton: UIButton {
    
    var shareType : ShareType {
        
        set(newV) {
            
            if newV == ShareType.ShareTypeWeChat {
                self.setImage(UIImage(named: "share_webchat_selected"), forState: UIControlState.Highlighted)
                self.setImage(UIImage(named: "share_webchat"), forState: UIControlState.Normal)
                self.setTitle("微信好友", forState: UIControlState.Normal)
            } else if newV == ShareType.ShareTypeWeibo {
                self.setImage(UIImage(named: "share_weibo_selected"), forState: UIControlState.Highlighted)
                self.setImage(UIImage(named: "share_weibo"), forState: UIControlState.Normal)
                self.setTitle("新浪微博", forState: UIControlState.Normal)
            } else if newV == ShareType.ShareTypeQQZone {
                self.setImage(UIImage(named: "share_qqzon_selected"), forState: UIControlState.Highlighted)
                self.setImage(UIImage(named: "share_qqzon"), forState: UIControlState.Normal)
                self.setTitle("QQ空间", forState: UIControlState.Normal)
            } else if newV == ShareType.ShareTypePengyouquan {
                self.setImage(UIImage(named: "share_session_selected"), forState: UIControlState.Highlighted)
                self.setImage(UIImage(named: "share_session"), forState: UIControlState.Normal)
                self.setTitle("微信朋友圈", forState: UIControlState.Normal)
            } else if newV == ShareType.ShareTypeCopy {
                self.setImage(UIImage(named: "share_copy_selected"), forState: UIControlState.Highlighted)
                self.setImage(UIImage(named: "share_copy"), forState: UIControlState.Normal)
                self.setTitle("复制链接", forState: UIControlState.Normal)
            } else {
                self.setImage(UIImage(named: "share_qq_selected"), forState: UIControlState.Highlighted)
                self.setImage(UIImage(named: "share_qq"), forState: UIControlState.Normal)
                self.setTitle("QQ", forState: UIControlState.Normal)
            }
        }
        
        get {
            return self.shareType
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment = NSTextAlignment.Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(0, 72, self.bounds.size.width, 15)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake((self.frame.size.width - 48) / 2.0, 15, 48, 48)
    }
}
