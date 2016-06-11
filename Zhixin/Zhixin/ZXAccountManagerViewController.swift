//
//  ZXAccountManagerViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXAccountManagerViewController: UIViewController, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    @IBOutlet var scroll : UIScrollView?
    var headButton : ZXProfileHeadButton?
    var nickButton : ZXProfileInfoButton?
    var jobButton : ZXProfileInfoButton?
    var sigButton : ZXProfileInfoButton?
    var mailButton : ZXProfileInfoButton?
    var passwordButton : ZXProfileInfoButton?
    var outButton : UIButton?
    var picker : UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true

        self.headButton = ZXProfileHeadButton(frame: CGRectMake(0, 15, UIScreen.mainScreen().bounds.size.width, 100))
        self.scroll?.addSubview(self.headButton!)
        self.scroll?.backgroundColor = Colors.UIColorFromRGB(0xeceff1)
        self.headButton?.addTarget(self, action: #selector(ZXAccountManagerViewController.headButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        if LoginedUser.sharedInstance.avatar?.characters.count <= 0 {
            self.headButton?.setImage(UIImage(named: "nIcon"), forState: UIControlState.Normal)
        }
        
        self.nickButton = ZXProfileInfoButton(frame: CGRectMake(0, (self.headButton?.frame.origin.y)! + (self.headButton?.frame.size.height)! + 15, UIScreen.mainScreen().bounds.size.width, 50))
        self.scroll?.addSubview(self.nickButton!)
        self.nickButton?.addTarget(self, action: #selector(ZXAccountManagerViewController.infoButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.nickButton?.setTitle("昵称", forState: UIControlState.Normal)
        self.nickButton?.sub = LoginedUser.sharedInstance.nickName
        
        self.jobButton = ZXProfileInfoButton(frame: CGRectMake(0, (self.nickButton?.frame.origin.y)! + (self.nickButton?.frame.size.height)!, UIScreen.mainScreen().bounds.size.width, 50))
        self.scroll?.addSubview(self.jobButton!)
        self.jobButton?.addTarget(self, action: #selector(ZXAccountManagerViewController.infoButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.jobButton?.setTitle("职位", forState: UIControlState.Normal)
        self.jobButton?.sub = LoginedUser.sharedInstance.job
        
        self.sigButton = ZXProfileInfoButton(frame: CGRectMake(0, (self.jobButton?.frame.origin.y)! + (self.jobButton?.frame.size.height)!, UIScreen.mainScreen().bounds.size.width, 50))
        self.scroll?.addSubview(self.sigButton!)
        self.sigButton?.addTarget(self, action: #selector(ZXAccountManagerViewController.infoButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.sigButton?.setTitle("个性签名", forState: UIControlState.Normal)
        self.sigButton?.sub = LoginedUser.sharedInstance.sig
        
        var pOrigin : CGFloat = CGFloat(0.0)
        
        
        self.mailButton = ZXProfileInfoButton(frame: CGRectMake(0, (self.sigButton?.frame.origin.y)! + (self.sigButton?.frame.size.height)! + 15, UIScreen.mainScreen().bounds.size.width, 50))
        self.scroll?.addSubview(self.mailButton!)
        self.mailButton?.addTarget(self, action: #selector(ZXAccountManagerViewController.infoButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.mailButton?.setTitle("邮箱", forState: UIControlState.Normal)
        self.mailButton?.subLabel.textColor = Colors.navigationColor()
        self.mailButton?.sub = "绑定邮箱"
        self.mailButton?.sub = LoginedUser.sharedInstance.mail
        self.mailButton?.userInteractionEnabled = LoginedUser.sharedInstance.mail?.characters.count <= 0
        
        pOrigin = (self.mailButton?.frame.origin.y)! + (self.mailButton?.frame.size.height)!
        
        self.passwordButton = ZXProfileInfoButton(frame: CGRectMake(0, pOrigin, (self.sigButton?.frame.size.width)!, 50))
        self.scroll?.addSubview(self.passwordButton!)
        self.passwordButton?.addTarget(self, action: #selector(ZXAccountManagerViewController.editButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.passwordButton?.setTitle("修改密码", forState: UIControlState.Normal)
        
        self.outButton = UIButton(frame: CGRectMake(0, (self.passwordButton?.frame.origin.y)! + (self.passwordButton?.frame.size.height)! + 15, (self.sigButton?.frame.size.width)!, 50))
        self.scroll?.addSubview(self.outButton!)
        self.outButton?.backgroundColor = UIColor.whiteColor()
        self.outButton?.addTarget(self, action: #selector(ZXAccountManagerViewController.outButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.outButton?.setTitle("退出登录", forState: UIControlState.Normal)
        self.outButton?.setTitleColor(Colors.navigationColor(), forState: UIControlState.Normal)
        
        self.picker = UIImagePickerController();
        picker?.view.backgroundColor = UIColor.blackColor()
        self.picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.picker!.delegate = self;
        self.picker!.allowsEditing = true;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headButton?.setImage(LoginedUser.sharedInstance.headI, forState: UIControlState.Normal)
        self.nickButton?.sub = LoginedUser.sharedInstance.nickName
        self.jobButton?.sub = LoginedUser.sharedInstance.job
        self.sigButton?.sub = LoginedUser.sharedInstance.sig
        self.mailButton?.sub = LoginedUser.sharedInstance.mail
        
        if LoginedUser.sharedInstance.avatar?.characters.count <= 0 {
            self.headButton?.setImage(UIImage(named: "nIcon"), forState: UIControlState.Normal)
        }
        
        if LoginedUser.sharedInstance.headI != nil {
            self.headButton?.setImage(LoginedUser.sharedInstance.headI, forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbuttonPressed(sender : AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func headButtonPressed(sender : AnyObject) {
        
        var actionView = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
        actionView.showInView(self.view)
    }
    
    func infoButtonPressed(sender : ZXProfileInfoButton) {
        
        let controller = ZXUpdateProfileInfoViewController(nibName: "ZXUpdateProfileInfoViewController", bundle: nil)
        
        if sender == self.nickButton {
            controller.ttt = updateType.nickName
        } else if sender == self.jobButton {
            controller.ttt = updateType.job
        } else if sender == self.sigButton {
            controller.ttt = updateType.sig
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func outButtonPressed(sender : UIButton) {
        let alert = UIAlertView()
//        alert.title = "Alert"
        alert.delegate = self
        alert.message = "确定要退出吗?"
        alert.addButtonWithTitle("确定")
        alert.addButtonWithTitle("取消")
        alert.show()
    }
    
    func editButtonPressed(sender : ZXProfileInfoButton) {
        let controller = ZXModifyPasswordViewController(nibName: "ZXModifyPasswordViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        title = actionSheet.buttonTitleAtIndex(buttonIndex)
        
        if title == "拍照" {
            self.picker!.sourceType = UIImagePickerControllerSourceType.Camera;
            
        } else if title == "相册" {
            self.picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        } else if title == "取消" {
            return;
        }
    
        self.presentViewController(self.picker!, animated: true, completion: nil)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        let title = alertView.buttonTitleAtIndex(buttonIndex)
        if title == "取消" {
            return
        } else {
            LoginedUser.sharedInstance.userID = 0
            LoginedUser.sharedInstance.syc()
            self.navigationController?.popViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName(kLogoutSuccess, object: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let ima = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.headButton?.setImage(ima, forState: UIControlState.Normal)
        LoginedUser.sharedInstance.headI = ima
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
