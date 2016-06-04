//
//  ZXNews.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

//"pno":3,"uno":1,"pid":"pid_103","name":"神奇百货 ","link":"http://static.shenqibuy.com/nginx/app.html","desc":"98年CEO 打造的一款最懂 95 后的购物 App，全面定义年轻人的购物新玩法","term":"神奇百货","type":1,"sign":0,"status":1,"score":0,"count":0,"date":"2015-12-21"

class ZXNews: ZXModel {
    
    var zaned : Bool
    var zans : Int32?
    var title : String?
    var content : String?
    var avatar : String?
    var link : String?
    var author : ZXUser?
    var pNo : NSInteger?
                  
    var publishTime : String?
    var zanAvatars : NSMutableArray?
    
    
    override init(dict: NSDictionary!) {
        
        self.zaned = false
        
        if dict.valueForKey("ilike") != nil {
            self.zaned = (dict.valueForKey("ilike") as? Bool)!
        }
//        if dict.valueForKey("status") != nil {
//            self.zaned = (dict.valueForKey("status") as? Bool)!
//        }
        
        self.zans = dict.valueForKey("score")?.intValue
        self.title = dict.valueForKey("name") as? String
        self.content = dict.valueForKey("desc") as? String
        self.link = dict.valueForKey("link") as? String
        self.pNo = dict.valueForKey("pno") as? NSInteger
        self.publishTime = dict.valueForKey("date") as? String
        
        self.author = ZXUser(dict: dict.valueForKey("user") as? NSDictionary)
        
        super.init(dict: dict)
    }
}
