//
//  LoginedUser.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

let kLoginSuccess = "kLoginSuccess"
let kLogoutSuccess = "kLogoutSuccess"

class LoginedUser: ZXUser {

    static let sharedInstance = LoginedUser()
    
    var headI : UIImage?
    
    private init() {
        super.init(dict: NSDictionary())
    }
    
    func syc() {
        NSUserDefaults.standardUserDefaults().setObject(self.nickName, forKey: "nickname")
        NSUserDefaults.standardUserDefaults().setObject(self.mail, forKey: "mail")
        NSUserDefaults.standardUserDefaults().setInteger(Int(self.userID!), forKey: "userID")
        if self.job != nil {
            NSUserDefaults.standardUserDefaults().setObject(self.job, forKey: "job")
        }
        if self.sig != nil {
            NSUserDefaults.standardUserDefaults().setObject(self.sig, forKey: "sig")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
