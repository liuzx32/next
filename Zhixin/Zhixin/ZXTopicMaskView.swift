//
//  ZXTopicMaskView.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

class ZXTopicMaskView: UIView {

    var im : UIImageView!
    var shadowT : ZXTopic?
    var topic : ZXTopic? {
        
        set(newV) {
            
            self.shadowT = newV
            
            self.titleLabel.text = newV?.name
            let str : String = String((newV?.products)!) + "产品" + " " + String((newV?.favos)!) + "收藏"
            self.infoLabel.text = str
            
            if newV?.favoed == true {
                self.favoButton.backgroundColor = Colors.navigationColor()
                self.favoButton.setTitle("已收藏", forState: UIControlState.Normal)
                self.favoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
            self.im.kf_setImageWithURL(NSURL(string: (newV?.imageURL)!)!)
        }
        
        get {
            return self.shadowT
        }
    }
    var titleLabel : UILabel!
    var infoLabel : UILabel!
    var favoButton : UIButton!
    var arr : UIImageView!
    var scLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        
        self.im = UIImageView(frame: frame)
        self.im.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.im)
        
        self.titleLabel = UILabel(frame: CGRectMake(0, 217, frame.size.width, 24))
        self.titleLabel.textAlignment = NSTextAlignment.Center
        self.titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.titleLabel)
        
        self.infoLabel = UILabel(frame: CGRectMake(0, 250, frame.size.width, 18))
        self.infoLabel.textColor = UIColor.whiteColor()
        self.infoLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(self.infoLabel)
        
        self.favoButton = UIButton(frame: CGRectMake((frame.size.width - 110) / 2, 308, 110, 44))
        self.favoButton.layer.cornerRadius = 4;
        self.favoButton.layer.borderColor = Colors.navigationColor().CGColor
        self.favoButton.backgroundColor = UIColor.clearColor()
        self.favoButton.setTitle("收藏", forState: UIControlState.Normal)
        self.favoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.addSubview(self.favoButton)
        self.favoButton.addTarget(self, action: #selector(ZXTopicMaskView.favoButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.favoButton.layer.cornerRadius = 4;
        self.favoButton.layer.borderWidth = 0.5
        self.favoButton.layer.borderColor = Colors.navigationColor().CGColor
        
        self.arr = UIImageView(frame: CGRectMake((frame.size.width - 15) / 2, frame.size.height - 77, 15, 9))
        self.arr.image = UIImage(named: "zan")
        self.addSubview(self.arr)
        
        self.scLabel = UILabel(frame: CGRectMake(0, frame.size.height - 55, frame.size.width, 12))
        self.scLabel.textColor = UIColor.whiteColor()
        self.scLabel.textAlignment = NSTextAlignment.Center
        self.scLabel.text = "scroll to view"
        self.addSubview(self.scLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func favoButtonPressed(sender : AnyObject) {
        
        let paras = ["tno" : String(self.topic?.topicNo)]
        
        if self.topic?.favoed == true {
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/lose/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                //            print("the response is \(response)")
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if response.response?.statusCode == 200 {
                        
                        self.favoButton.backgroundColor = UIColor.clearColor()
                        self.favoButton.setTitle("收藏", forState: UIControlState.Normal)
                        self.favoButton.setTitleColor(Colors.navigationColor(), forState: UIControlState.Normal)
                        self.favoButton.layer.borderWidth = 0.5
                        self.favoButton.layer.borderColor = Colors.navigationColor().CGColor
                        self.topic?.favoed = false
                        
                    } else {
                        // 登录
                        print("等录取")
                        let login  = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
                        self.makeToast(message: "请重新登录")
                    }
                    
                } catch {
                    
                }
            })
            
        } else {
         
            Alamofire.request(.POST, "http://www.npinfang.com/apps/gain/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                //            print("the response is \(response)")
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    if response.response?.statusCode == 200 {
                        
                        self.favoButton.backgroundColor = Colors.navigationColor()
                        self.favoButton.setTitle("已收藏", forState: UIControlState.Normal)
                        self.favoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                        self.makeToast(message: "收藏成功")
                        self.topic?.favoed = true
                        
                    } else {
                        // 登录
                        print("等录取")
                        self.makeToast(message: "请重新登录")
                    }
                    
                } catch {
                    
                }
            })
        }
    }
}
