//
//  ZXProductComment.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/13.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

//{
//    cno = 48;
//    content = kkkk;
//    date = "2016-05-28 16:39:41";
//    pno = 35317;
//    state = 1;
//    time = 1464424781000;
//    uno = 15;
//    user =                 {
//        desc = "<null>";
//        email = "123@a.com";
//        icon = "http://source.npinfang.com/user-h.jpg";
//        nick = hhh;
//        share = "http://www.npinfang.com/user/15";
//        uno = 15;
//        work = "<null>";
//    };
//}

class ZXProductComment: ZXModel {
    
    var avatar : String?
    var nickName : String?
    var content : String?
    var date : String?

    override init(dict: NSDictionary!) {
        super.init(dict: dict)
        
        var ds = dict["date"] as? String
        if ds != nil {
            let dss = ds?.componentsSeparatedByString(" ")
            self.date = dss![0]
        }
        self.avatar = dict["user"]!["icon"] as? String
        self.nickName = dict["user"]!["nick"] as? String
        self.content = dict["content"] as? String
    }
}
