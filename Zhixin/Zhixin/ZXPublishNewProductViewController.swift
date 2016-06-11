//
//  ZXPublishNewProductViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/12.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

enum NewType {
    case newTypeProduct
    case newTypeTopic
}

class ZXPublishNewProductViewController: UIViewController {
    
    @IBOutlet var backButton : UIButton?
    @IBOutlet var publishButton : UIButton?
    @IBOutlet var nameFiled : UITextField?
    @IBOutlet var netFiled : UITextField?
    @IBOutlet var desField : UITextField?
    @IBOutlet var bottomLine : UIView?
    @IBOutlet var tLabel : UILabel?
    @IBOutlet var naviView : UIView?
    
    var toTopic : ZXTopic?
    
    var tt : NewType?
    
    init(type : NewType) {
        super.init(nibName: "ZXPublishNewProductViewController", bundle: nil)
        
        self.tt = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.hidden = true
        self.naviView?.backgroundColor = Colors.navigationColor()
        // Do any additional setup after loading the view.
        
        if self.tt == NewType.newTypeTopic {
            self.tLabel?.text = "新建主题"
            self.bottomLine?.hidden = true
            self.desField?.hidden = true
            self.nameFiled?.placeholder = "主题名称"
            self.netFiled?.placeholder = "主题描述"
        } else if self.tt == NewType.newTypeProduct {
            self.tLabel?.text = "发布新产品"
            self.bottomLine?.hidden = false
            self.desField?.hidden = false
            self.nameFiled?.placeholder = "产品名称"
            self.netFiled?.placeholder = "产品官网"
            self.desField?.placeholder = "一句话描述"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.nameFiled?.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender : AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func publishButtonPressed(sender : AnyObject) {
        
        if self.tt == NewType.newTypeProduct {
            //http://test.npinfang.com/apps/post/item
            
            if self.nameFiled?.text?.characters.count <= 0 || self.desField?.text?.characters.count <= 0 || self.netFiled?.text?.characters.count <= 0 {
                self.view.makeToast(message: "请输入相关信息")
                return
            }
            
            self.view.makeToastActivity()
            
            var paras = ["itemName" : self.nameFiled!.text!,
                         "itemLink" : self.netFiled!.text!,
                         "itemDesc" : self.desField!.text!]
            
            if self.toTopic != nil {
                 paras = ["itemName" : self.nameFiled!.text!,
                             "itemLink" : self.netFiled!.text!,
                             "itemDesc" : self.desField!.text!,
                             "tno" : String(self.toTopic?.topicNo)]
            }
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/post/item", parameters: paras).responseJSON(completionHandler: { (response) in
                print("the response is \(response)")
                
                self.view.hideToastActivity()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"])")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        UIApplication.sharedApplication().keyWindow?.makeToast(message: "修改成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        self.view.makeToast(message: "服务器故障")
                    }
                    
                } catch {
                    
                }
            })
        } else if self.tt == NewType.newTypeTopic {
            
            if self.nameFiled?.text?.characters.count <= 0 || self.netFiled?.text?.characters.count <= 0 {
                self.view.makeToast(message: "请输入相关信息")
                return
            }
            
//            http://test.npinfang.com/apps/post/topic
        
            self.view.makeToastActivity()
            
            let paras = ["topicName" : self.nameFiled!.text!,
                         "topicDesc" : self.desField!.text!]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/post/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                print("the response is \(response)")
                
                self.view.hideToastActivity()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"])")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        UIApplication.sharedApplication().keyWindow?.makeToast(message: "修改成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        self.view.makeToast(message: "服务器故障")
                    }
                    
                } catch {
                    
                }
            })
        }
    }
}
