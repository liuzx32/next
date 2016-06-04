//
//  ZXUser.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXUser: ZXModel {
    
    var nickName : String?
    var avatar : String?
    var userID : Int32?
    var mail : String?
    var job : String?
    var sig : String?
    
    override init(dict: NSDictionary!) {
        self.nickName = dict["nick"] as?  String
        self.avatar = dict["icon"] as? String
        self.userID = dict["uno"] as? Int32
        self.mail = dict["email"] as? String
        self.job = dict["job"] as? String
        self.sig = dict["desc"] as? String
        
        super.init(dict: dict)
    }
}
