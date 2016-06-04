//
//  ZXAccountLoginViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/12.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

enum LoginType {
    case LoginTypeLogin
    case LoginTypeRegister
    case LoginTypeForgot
    case LoginTypeBindEmail
}

class ZXAccountLoginViewController: UIViewController {
    
    @IBOutlet var backButton : UIButton?
    @IBOutlet var forgotButton : UIButton?
    @IBOutlet var mailField : UITextField?
    @IBOutlet var passwordField : UITextField?
    @IBOutlet var loginButton : UIButton?
    @IBOutlet var titleLabel : UILabel?
    
    @IBOutlet var passwordImage : UIImageView?
    @IBOutlet var passwordLine : UIView?
    var shadowLo : LoginType?
    
    var loType : LoginType? {
        
        set(newV) {
            
            shadowLo = newV!
            
            if newV! == LoginType.LoginTypeLogin {
                self.titleLabel?.text = "登录"
                self.loginButton?.setTitle("登录", forState: UIControlState.Normal)
            } else if newV! == LoginType.LoginTypeRegister {
                
                self.titleLabel?.text = "注册"
                self.forgotButton?.hidden = true;
                self.loginButton?.setTitle("注册", forState: UIControlState.Normal)
            } else if newV == LoginType.LoginTypeForgot {
                
                self.titleLabel?.text = "忘记密码"
                self.forgotButton?.hidden = true;
                self.loginButton?.setTitle("发送重置密码请求", forState: UIControlState.Normal)
                self.passwordField?.hidden = true
                
            } else if newV == LoginType.LoginTypeBindEmail {
                
                self.titleLabel?.text = "绑定邮箱"
                self.loginButton?.hidden = false;
                self.forgotButton?.hidden = true
                self.loginButton?.setTitle("提交", forState: UIControlState.Normal)
            }
        }
        
        get {
            
            return shadowLo
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.hidden = true
        
        let newV = shadowLo
        if newV == LoginType.LoginTypeLogin {
            self.titleLabel?.text = "登录"
            self.loginButton?.setTitle("登录", forState: UIControlState.Normal)
        } else if newV == LoginType.LoginTypeRegister {
            
            self.titleLabel?.text = "注册"
            self.forgotButton?.hidden = true;
            self.loginButton?.setTitle("注册", forState: UIControlState.Normal)
        } else if newV == LoginType.LoginTypeForgot {
            
            self.titleLabel?.text = "忘记密码"
            self.forgotButton?.hidden = true;
            self.loginButton?.setTitle("发送重置密码请求", forState: UIControlState.Normal)
            self.passwordField?.hidden = true
            self.passwordLine?.hidden = true
            
        } else if newV == LoginType.LoginTypeBindEmail {
            
            self.titleLabel?.text = "绑定邮箱"
            self.loginButton?.hidden = false;
            self.forgotButton?.hidden = true
            self.loginButton?.setTitle("提交", forState: UIControlState.Normal)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonPressed(sender:AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func forgotButtonPressed(sender : AnyObject) {
        let controller = ZXAccountLoginViewController(nibName: "ZXAccountLoginViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
        controller.loType = LoginType.LoginTypeForgot
    }
    
    @IBAction func loginButtonPressed(sender : AnyObject) {
        
        let newV = shadowLo
        if newV == LoginType.LoginTypeLogin {
            
            let parameters = [
                "userAccount": self.mailField!.text!,
                "userPasswd": self.passwordField!.text!,
                ]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/signin", parameters: parameters).responseJSON(completionHandler: {response in
                
                if response.response?.statusCode == 200 {
                    
                    UIApplication.sharedApplication().keyWindow?.makeToast(message: "登录成功")
                    LoginedUser.sharedInstance.mail = self.mailField?.text
//                    LoginedUser.sharedInstance.nickName = "N品方"
                    LoginedUser.sharedInstance.userID = 1
                    LoginedUser.sharedInstance.syc()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName(kLoginSuccess, object: nil)
                } else {
                    
                    UIApplication.sharedApplication().keyWindow?.makeToast(message: "登录失败")
                }
            })//测试帐号 123@a.com 111111
        } else if newV == LoginType.LoginTypeRegister {
            
            let parameters = [
                "userEmail": self.mailField!.text!,
                "userPasswd": self.passwordField!.text!,
            ]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/signup/email", parameters: parameters).responseJSON(completionHandler: {response in
                
                
                let cook = response.response?.allHeaderFields["Set-Cookie"] as? String
                print("cookie is \(cook)")
                if response.response?.statusCode == 200 {
                    
                    UIApplication.sharedApplication().keyWindow?.makeToast(message: "注册成功")
                    LoginedUser.sharedInstance.mail = self.mailField?.text
                    LoginedUser.sharedInstance.nickName = "N品方"
                    LoginedUser.sharedInstance.userID = 1
                    LoginedUser.sharedInstance.syc()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName(kLoginSuccess, object: nil)
                    
                    let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(response.response!.allHeaderFields as! [String: String], forURL: response.response!.URL!)
                    Alamofire.Manager.sharedInstance.session.configuration.HTTPCookieStorage?.setCookies(cookies, forURL: NSURL(string: "http://www.npinfang.com/"), mainDocumentURL: nil)
                } else {
                    
                    UIApplication.sharedApplication().keyWindow?.makeToast(message: "注册失败")
                }
            })//测试帐号 123@a.com 111111
        } else if newV == LoginType.LoginTypeForgot {
            
//            self.titleLabel?.text = "忘记密码"
//            self.forgotButton?.hidden = true;
//            self.loginButton?.setTitle("发送重置密码请求", forState: UIControlState.Normal)
//            self.passwordField?.hidden = true
//            self.passwordLine?.hidden = true
            
        } else if newV == LoginType.LoginTypeBindEmail {
            
//            self.titleLabel?.text = "绑定邮箱"
//            self.loginButton?.hidden = false;
//            self.forgotButton?.hidden = true
//            self.loginButton?.setTitle("提交", forState: UIControlState.Normal)
        }
    }

}
