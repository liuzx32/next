//
//  ZXProfileHeaderView.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate {
    
    func registerButtonPressed()
    func avatarButtonPressed()
}

class ZXProfileHeaderView: UIView {

    @IBOutlet var avatar : UIImageView?
    @IBOutlet var avatarButton : UIButton?
    @IBOutlet var nameLabel : UILabel?
    @IBOutlet var levelLabel : UILabel?
    @IBOutlet var desLabel : UILabel?
    @IBOutlet var sepView : UIView?
    @IBOutlet var loginButton : UIButton?
    var delegate : ProfileHeaderViewDelegate?
    
    var user : ZXUser? {
        
        set(newV) {
            
            if newV?.userID > 0 {
                self.avatar?.image = UIImage(named: "")
                if newV?.avatar?.characters.count <= 0 {
                    self.avatar?.image = UIImage(named: "nIcon")
                } else {
                    self.avatar?.kf_setImageWithURL(NSURL(string: (newV?.avatar)!)!, placeholderImage: UIImage(named: "nIcon"))
                }
                
                self.nameLabel?.text = newV?.nickName
                self.levelLabel?.text = newV?.job
                self.levelLabel?.hidden = false
                self.desLabel?.hidden = false
                self.desLabel?.text = newV?.sig
                self.sepView?.hidden = false
                self.loginButton?.hidden = true
                self.avatarButton?.userInteractionEnabled = true
            } else {
                
                self.avatar?.image = UIImage(named: "anoymous")
                self.nameLabel?.text = "点击登录"
                self.levelLabel?.text = ""
                self.levelLabel?.hidden = true
                self.desLabel?.hidden = true
                self.desLabel?.text = ""
                self.sepView?.hidden = true
                self.loginButton?.hidden = false
                self.avatarButton?.userInteractionEnabled = false
            }
        }
        
        get {
            return user
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel?.text = "点击登录"
        self.levelLabel?.hidden = true
        self.desLabel?.hidden = true
        self.sepView?.hidden = true
        self.loginButton?.hidden = false
        
        self.avatar?.layer.cornerRadius = (self.avatar?.frame.size.height)! / 2;
        self.avatar?.layer.borderWidth = 1
        self.avatar?.layer.borderColor = UIColor.whiteColor().CGColor
        self.avatar?.contentMode = UIViewContentMode.ScaleAspectFill
        self.avatar?.clipsToBounds = true
    }
    
    @IBAction func loginButtonPressed(sender : AnyObject) {
        
        self.delegate?.registerButtonPressed()
    }
    
    @IBAction func avatarButtonPressed(sender : AnyObject) {
        
        self.delegate?.avatarButtonPressed()
    }
}
