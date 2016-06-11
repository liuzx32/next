//
//  ZXTopic.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

//desc = "<null>";
//*gains = 0;
//*igain = 0;
//＊image = "http://7xs88m.com2.z0.glb.qiniucdn.com/015.jpg";
//*items = 0;
//*name = "\U4ea7\U54c1\U5947\U8469\Uff0c\U4f46\U771f\U6709\U4eba\U4e70\U8d26\U554a\U5582";
//*share = "http://www.npinfang.com/topic/15";
//*tid = nt0114593083070015;
//tno = 15;
//type = 0;
//uno = 2;

class ZXTopic: ZXModel {

    var imageURL : String?
    var name : String?
    var products : Int32?
    var favos : Int32?
    var favoed : Bool?
    var tid : String?
    var shareURL : String?
    var topicNo : NSInteger?
    
    
    override init(dict: NSDictionary!) {
        self.imageURL = dict.valueForKey("image") as? String
        self.name = dict.valueForKey("name") as? String
        self.products = (dict.valueForKey("items") as? NSNumber)?.intValue
        self.favos = (dict.valueForKey("gains") as? NSNumber)?.intValue
        self.favoed = (dict.valueForKey("igain") as? NSNumber)?.boolValue
        self.tid = dict.valueForKey("tid") as? String
        self.shareURL = dict.valueForKey("share") as? String
        self.topicNo = dict.valueForKey("tno") as? NSInteger
        
        super.init(dict: dict)
    }
}
