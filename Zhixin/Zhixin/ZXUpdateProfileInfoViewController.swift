//
//  ZXUpdateProfileInfoViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

enum updateType {
    case nickName
    case job
    case sig
    case mail
}

class ZXUpdateProfileInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var contentF : UITextField?
    @IBOutlet var countLabel : UILabel?
    var shadow : updateType?
    var ttt : updateType {
        
        set (newV) {
            
            shadow = newV
            
            if newV == updateType.nickName {
                self.titleLabel?.text = "昵称"
            } else if newV == updateType.job {
                self.titleLabel?.text = "职位"
            } else if newV == updateType.sig {
                self.titleLabel?.text = "签名"
            } else if newV == updateType.mail {
                self.titleLabel?.text = "邮箱"
            }
        }
        
        get {
            return shadow!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentF?.delegate = self;
        
        var type = self.ttt
        
        if type == updateType.nickName {
            self.titleLabel?.text = "昵称"
            self.contentF?.text = LoginedUser.sharedInstance.nickName
            self.countLabel?.text = String(16 - (self.contentF?.text?.characters.count)!)
            
        } else if type == updateType.job {
            self.titleLabel?.text = "职位"
            self.contentF?.text = LoginedUser.sharedInstance.job
            self.countLabel?.text = String(16 - (self.contentF?.text?.characters.count)!)
        } else if type == updateType.sig {
            self.titleLabel?.text = "签名"
            self.contentF?.text = LoginedUser.sharedInstance.sig
            self.countLabel?.text = String(16 - (self.contentF?.text?.characters.count)!)
        } else if type == updateType.mail {
            
            self.titleLabel?.text = "邮箱"
            self.contentF?.text = LoginedUser.sharedInstance.mail
            self.countLabel?.text = String(16 - (self.contentF?.text?.characters.count)!)
        }
        
        self.contentF?.addTarget(self, action: #selector(ZXUpdateProfileInfoViewController.valueChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender : UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveButtonPressed(sender : UIButton) {
        var type = self.ttt
        
        if type == updateType.nickName {
//            self.titleLabel?.text = "昵称"
            LoginedUser.sharedInstance.nickName = self.contentF?.text
            LoginedUser.sharedInstance.syc()
            self.navigationController?.popViewControllerAnimated(true)
            
            let para = [
                "userNick": self.contentF!.text!,
                ]
            
            Alamofire.request(.POST, "http://www.npinfang.com/save/user/info", parameters: para).responseJSON(completionHandler: { (response) in
                print("the response is \(response)")
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    UIApplication.sharedApplication().keyWindow!.makeToast(message: "修改成功")
                }
            })
        } else if type == updateType.job {
//            self.titleLabel?.text = "职位"
            LoginedUser.sharedInstance.job = self.contentF?.text
            LoginedUser.sharedInstance.syc()
            self.navigationController?.popViewControllerAnimated(true)
            
            let para = [
                "userWork": self.contentF!.text!,
                ]
            
            Alamofire.request(.POST, "http://www.npinfang.com/save/user/info", parameters: para).responseJSON(completionHandler: { (response) in
                print("the response is \(response)")
                let statusCode = response.response?.statusCode
                if statusCode == 200 {
                    UIApplication.sharedApplication().keyWindow!.makeToast(message: "修改成功")
                }
            })
        } else if type == updateType.sig {
//            self.titleLabel?.text = "签名"
            LoginedUser.sharedInstance.sig = self.contentF?.text
            LoginedUser.sharedInstance.syc()
            self.navigationController?.popViewControllerAnimated(true)
            
            let para = [
                "userDesc": self.contentF!.text!,
                ]
            
            Alamofire.request(.POST, "http://www.npinfang.com/save/user/info", parameters: para).responseJSON(completionHandler: { (response) in
                print("the response is \(response)")
//                let statusCode = response.response?.statusCode
//                if statusCode == 200 {
//                    UIApplication.sharedApplication().keyWindow!.makeToast(message: "修改成功")
//                }
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"])")
                    
                    let datas = JSON["data"]!
                    
                    let code = datas!["code"]!!.integerValue
                    if code == 200 {
                        
                        UIApplication.sharedApplication().keyWindow?.makeToast(message: "修改成功")
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                    }
                    
//                    var zans = datas!["likes"]!!.integerValue
//                    
//                    let zan = "点赞" + String(zans)
//                    let pub = "发布" + String(datas!["gives"]!!.integerValue)
//                    let fav = "收藏" + String(datas!["gains"]!!.integerValue)
//                    
//                    self.zanButton?.setTitle(zan, forState: UIControlState.Normal)
//                    self.pubButton?.setTitle(pub, forState: UIControlState.Normal)
//                    self.topButton?.setTitle(fav, forState: UIControlState.Normal)
//                    
//                    let icon = datas!["icon"]!!
//                    self.staleHeader.avatar?.kf_setImageWithURL(NSURL.fileURLWithPath(icon as! String), placeholderImage: UIImage(named: "nIcon"))
                    
                } catch {
                    
                }
            })
        } else if type == updateType.mail {
            LoginedUser.sharedInstance.mail = self.contentF?.text
            LoginedUser.sharedInstance.syc()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func valueChanged(sender : UITextField) {
        
        self.countLabel?.text = String(16 - (sender.text?.characters.count)!)
    }
}
