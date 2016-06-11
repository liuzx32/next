//
//  ZXFeedbackViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXFeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var placeHolder : UILabel?
    @IBOutlet var advice : UITextView?
    @IBOutlet var contact : UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.advice?.delegate = self
        self.tabBarController?.tabBar.hidden = true
        
        self.advice?.layer.cornerRadius = 4;
        self.advice?.layer.borderWidth = 0.5
        self.advice?.layer.borderColor = Colors.UIColorFromRGB(0xc8c8c8).CGColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender : UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func submitButtonPressed(sender : UIButton) {
        
        UIApplication.sharedApplication().keyWindow?.makeToast(message: "反馈成功")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        self.placeHolder?.hidden = textView.text.characters.count > 0
    }
}
