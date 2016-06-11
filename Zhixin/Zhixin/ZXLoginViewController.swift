//
//  ZXLoginViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXLoginViewController: UIViewController {
    
    @IBOutlet var loginButton : UIButton?
    @IBOutlet var registerButton : UIButton?
    @IBOutlet var weChatButton : UIButton?
    @IBOutlet var weiboButton : UIButton?
    @IBOutlet var skipButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.loginButton?.layer.cornerRadius = 4;
        self.registerButton?.layer.cornerRadius = 4;
        self.registerButton?.layer.borderWidth = 0.5
        self.registerButton?.layer.borderColor = UIColor.whiteColor().CGColor
    }

    @IBAction func loginButtonPressed(sender: AnyObject) {
        let controller = ZXAccountLoginViewController(nibName: "ZXAccountLoginViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
        controller.loType = LoginType.LoginTypeLogin
    }

    @IBAction func skipButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func weiboButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func weChatButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        let controller = ZXAccountLoginViewController(nibName: "ZXAccountLoginViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
        controller.loType = LoginType.LoginTypeRegister
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
