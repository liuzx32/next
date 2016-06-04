//
//  ZXProductDetaiHeaderView.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/13.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

//接口：适用于App端
//http://test.npinfang.com/safe/vote/item
//调整为：http://test.npinfang.com/apps/vote/item
//#
//参数：post请求
//pno=1,  其中pno即为产品编号
//说明：目前默认投票得一分，下个版本依据用户rank投票得分；
//会判断用户处于登录状态，目前默认投票得1分；
//返回数据（Json）：
//{"code":200,"msg":"success","data":{"score":3}}
//{"code":600,"msg":"User permission denied."}



import UIKit
import Alamofire

class ZXProductDetaiHeaderView: UIView {
    
    var shadowN : ZXNews?
    
    var news : ZXNews? {
        
        set (newV) {
            
            shadowN = newV
            
            self.zanLabel?.text = String((newV?.zans)!)
            self.titleLabel?.text = newV?.title;
            self.contentLabel?.text = newV?.content
            self.avatar?.kf_setImageWithURL(NSURL(string: (newV?.author?.avatar)!)!)
            self.timeLabel?.text = newV?.publishTime
            self.zanscountLabel?.text = String((newV?.zans)!) + "人觉得很赞"
            
            var rect = self.contentLabel?.frame
            rect?.size.height = (newV?.content?.heightWithConstrainedWidth((rect?.size.width)!, font: (self.contentLabel?.font)!))!
            self.contentLabel?.frame = rect!
            
            if (newV?.zans)! <= 0 {
                rect = self.frame
                rect?.size.height = 172
                self.frame = rect!
                
                self.zanLine?.hidden = true
                self.zanscountLabel?.hidden = true
                self.commentsLabel?.frame = (self.zanscountLabel?.frame)!
            } else {
                rect = self.frame
                rect?.size.height = 250
                self.frame = rect!
                
                self.zanscountLabel?.hidden = false
                self.zanLine?.hidden = false
                self.commentsLabel?.frame = CGRectMake(15, 231, 151, 21)
            }
            
            if newV?.zaned == true {
                self.zanButton?.layer.borderColor = Colors.navigationColor().CGColor
                self.zanLabel?.textColor = Colors.navigationColor()
            } else {
                self.zanLabel?.textColor = Colors.UIColorFromRGB(0x757575)
                self.zanButton?.layer.borderColor = Colors.UIColorFromRGB(0x757575).CGColor
            }
        }
        
        get {
            return self.shadowN
        }
    }
    
    @IBOutlet var zanButton : UIButton?
    @IBOutlet var zanLabel : UILabel?
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var contentLabel : UILabel?
    @IBOutlet var avatar : UIImageView?
    @IBOutlet var timeLabel : UILabel?
    @IBOutlet var zanscountLabel : UILabel?
    @IBOutlet var commentsLabel: UILabel?
    @IBOutlet var zanLine : UIView?
    var avatars : NSMutableArray?
    var zanedPersons : NSMutableArray?
    
    override func awakeFromNib() {
        self.zanButton?.layer.borderWidth = 0.5
        self.zanButton?.layer.borderColor = Colors.UIColorFromRGB(0x757575).CGColor
        self.zanButton?.layer.cornerRadius = 4
        
        self.zanedPersons = NSMutableArray()
        self.avatars = NSMutableArray()
        
        self.contentLabel?.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 135.0;
        
        self.avatar?.layer.cornerRadius = (self.avatar?.frame.size.height)! / 2.0
        self.avatar?.clipsToBounds = true
    }
    
    func getPersons() {
        
        self.zanButton?.userInteractionEnabled = false
        
        let paras = ["pno" : String((self.news?.pNo)!), "page" : "1", "rows" : "15",]
        
        Alamofire.request(.POST, "http://www.npinfang.com/item/vote/user/list", parameters: paras).responseJSON(completionHandler: { (response) in
            //            print("the response is \(response)")
            
            self.zanButton?.userInteractionEnabled = true
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //                print("the Json is \(JSON)")
                print("so the data is \(JSON["data"]!)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    
//                    self.topics?.removeAllObjects()
//                    for i in 0...self.avatars?.count {
//                        
//                        let button = self.avatars[i] as! UIButton
//                        button.removeFromSuperview()
//                    }
                    
                    for bu in self.avatars as! [UIButton] {
                        bu.removeFromSuperview()
                    }
                    
                    self.avatars!.removeAllObjects()
                    self.zanedPersons!.removeAllObjects()
                    
                    let data = JSON["data"]
                    let list = data!!["list"]! as? NSArray
                    if list != nil {
                        
                        for dict in list! {
    
                            let user = ZXUser(dict: dict as! NSDictionary)
                            self.zanedPersons?.addObject(user)
                        }
                    }
                    
                    for(var i = 0; i < self.zanedPersons?.count; i += 1) {
                        
                        let uu = self.zanedPersons?.objectAtIndex(i) as? ZXUser
                        
                        var ava = UIButton(frame: CGRectMake(15 + CGFloat(i) * (10 + 40), (self.zanscountLabel?.frame.origin.y)! + (self.zanscountLabel?.frame.size.height)! + 10, 40, 40))
                        ava.layer.cornerRadius = 20
                        ava.clipsToBounds = true
                        self.addSubview(ava)
                        ava.kf_setImageWithURL(NSURL(string: (uu?.avatar)!)!, forState: UIControlState.Normal)
                        self.avatars?.addObject(ava)
                    }
                    
                } else {
                    
                }
                
            } catch {
                
            }
        })
    }
    
    @IBAction func zanPressed(sender : AnyObject) {
        
        self.shadowN?.zaned = !(self.shadowN?.zaned)!
        
        if self.shadowN?.zaned == true {
            self.zanButton?.layer.borderColor = Colors.navigationColor().CGColor
            self.zanLabel?.textColor = Colors.navigationColor()
            
            let paras = ["pno" : String((self.news?.pNo)!)]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/vote/item", parameters: paras).responseJSON(completionHandler: { (response) in
                //            print("the response is \(response)")
                
                self.zanButton?.userInteractionEnabled = true
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        self.getPersons()
                        let data = JSON["data"] as? NSDictionary
                        let score = data?.valueForKey("score") as! NSInteger
                        
                        self.zanLabel?.text = String(score)
                        self.zanscountLabel?.text = String(score) + "人觉得很赞"
                        
                    } else {
                        
                    }
                    
                } catch {
                    
                }
            })
        } else {
            self.zanLabel?.textColor = Colors.UIColorFromRGB(0x757575)
            self.zanButton?.layer.borderColor = Colors.UIColorFromRGB(0x757575).CGColor
            
            let paras = ["pno" : String((self.news?.pNo)!)]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/lose/item", parameters: paras).responseJSON(completionHandler: { (response) in
                
                self.zanButton?.userInteractionEnabled = true
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        self.getPersons()
                        let data = JSON["data"] as? NSDictionary
                        
                        let score = data?.valueForKey("score") as! NSInteger
                        
                        self.zanLabel?.text = String(score)
                        self.zanscountLabel?.text = String(score) + "人觉得很赞"
                        
                    } else {
                        
                    }
                    
                } catch {
                    
                }
            })
        }

    }
}
