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
                }
                self.nameLabel?.text = newV?.nickName
                self.levelLabel?.text = ""
                self.levelLabel?.hidden = false
                self.desLabel?.hidden = false
                self.desLabel?.text = ""
                self.sepView?.hidden = false
                self.loginButton?.hidden = true
            } else {
                
                self.avatar?.image = UIImage(named: "")
                self.nameLabel?.text = "点击登录"
                self.levelLabel?.text = ""
                self.levelLabel?.hidden = true
                self.desLabel?.hidden = true
                self.desLabel?.text = ""
                self.sepView?.hidden = true
                self.loginButton?.hidden = false
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
    }
    
    @IBAction func loginButtonPressed(sender : AnyObject) {
        
        self.delegate?.registerButtonPressed()
    }
    
    @IBAction func avatarButtonPressed(sender : AnyObject) {
        
        self.delegate?.avatarButtonPressed()
    }
}
