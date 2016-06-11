//
//  ZXAvatarView.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/6/4.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXAvatarView: UIView {
    
    var button : UIButton?
    var ava : UIImageView?
    var user : ZXUser? {
        set(newV) {
            self.ava!.kf_setImageWithURL(NSURL(string: (newV?.avatar)!)!, placeholderImage: UIImage(named: "nIcon"))
        }
        
        get {
            return nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.ava = UIImageView(frame: self.bounds)
        self.button = UIButton(frame: self.bounds)
        self.ava?.contentMode = UIViewContentMode.ScaleAspectFill
        self.ava?.clipsToBounds = true
        self.ava?.layer.cornerRadius = self.bounds.size.height / 2.0
        self.addSubview(self.ava!)
        self.addSubview(self.button!)
        self.button?.backgroundColor  = UIColor.clearColor()
        self.button?.addTarget(self, action: #selector(ZXAvatarView.buttonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func buttonPressed(sender : AnyObject) {
        let vc = ZXPersonViewController(nibName: "ZXPersonViewController", bundle: nil)
        vc.user = self.user
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
