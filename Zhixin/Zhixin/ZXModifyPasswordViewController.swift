//
//  ZXModifyPasswordViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

class ZXModifyPasswordViewController: UIViewController {
    
    @IBOutlet var oriPassField : UITextField?
    @IBOutlet var newPassField : UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButtonPressed(sender : UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveButtonPressed(sender : UIButton) {
        
        let parameters = [
            "oldPasswd": self.oriPassField!.text!,
            "newPasswd": self.newPassField!.text!,
            ]
        
        Alamofire.request(.POST, "http://www.npinfang.com/save/user/auth", parameters: parameters).responseJSON(completionHandler: {response in
            
            if response.response?.statusCode == 200 {
                
                UIApplication.sharedApplication().keyWindow?.makeToast(message: "修改成功")
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
}
