//
//  MyViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/9.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileHeaderViewDelegate {
    
    var navigationView : UIView!
    var icon : UIImageView!
    var searchButton : UIButton!
    var addButton : UIButton!
    var tableView : UITableView!
    var headerView : ZXProfileHeaderView!
    var rows : NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyViewController.loginSuccess), name: kLoginSuccess, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyViewController.logoutSuccess), name: kLogoutSuccess, object: nil)
        
        let topEm = []
        let manage = ["im" : "manage" , "title" : "账号管理" , "sub" : ""]
        let myP = ["im" : "profile" , "title" : "我的主页" , "sub" : ""]
        let midEm = []
        let advice = ["im" : "advice" , "title" : "意见反馈" , "sub" : ""]
        let about = ["im" : "about" , "title" : "关于我们" , "sub" : ""]
        let update = ["im" : "update" , "title" : "版本更新" , "sub" : ""]
        
        self.rows = NSMutableArray(array: [topEm, manage, myP, midEm, advice, about, update])
        
        self.navigationView = UIView(frame: CGRectMake(0, 0, self.view!.frame.size.width, 64))
        self.navigationView.backgroundColor = Colors.UIColorFromRGB(0x0097e0)
        
        self.icon = UIImageView(frame: CGRectMake(15, 25, 30, 30))
        self.icon.backgroundColor = UIColor.clearColor()
        self.icon.contentMode = UIViewContentMode.ScaleAspectFit
        self.icon.image = UIImage(named: "nIcon")
        self.navigationView.addSubview(self.icon)
        
        self.searchButton = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, 5, 54, 54))
        self.searchButton.addTarget(self, action: #selector(MyViewController.searchButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.searchButton.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        self.navigationView.addSubview(self.searchButton)
        
        self.addButton = UIButton(frame: CGRectMake(self.view.frame.size.width - 60, 5, 54, 54))
        self.addButton.addTarget(self, action: #selector(MyViewController.addButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addButton.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        self.navigationView.addSubview(self.addButton)
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "ZXProfileCell", bundle:nil), forCellReuseIdentifier: "profileCell")
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.backgroundColor = Colors.UIColorFromRGB(0xf2f2f2)
        
        self.headerView = NSBundle.mainBundle().loadNibNamed("ZXProfileHeaderView", owner: nil, options: nil)[0] as! ZXProfileHeaderView
        self.headerView.backgroundColor = Colors.navigationColor()
        self.headerView.autoresizingMask = UIViewAutoresizing.None
        self.tableView.tableHeaderView = self.headerView
        self.headerView.delegate = self;
        
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.navigationView)
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        if LoginedUser.sharedInstance.userID <= 0 {
            let loginViewcontroller = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
            let navi = UINavigationController(rootViewController: loginViewcontroller)
            navi.navigationBar.hidden = true
            self.presentViewController(navi, animated: true, completion: {
                
            })
        } else {
            self.headerView.user = LoginedUser.sharedInstance
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    func searchButtonPressed(sender : UIButton) {
        print("search!")
    }
    
    func addButtonPressed(sender : UIButton) {
        
        if LoginedUser.sharedInstance.userID <= 0 {
            let loginViewcontroller = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
            let navi = UINavigationController(rootViewController: loginViewcontroller)
            navi.navigationBar.hidden = true
            self.presentViewController(navi, animated: true, completion: {
                
            })
        } else {
            let controller = ZXPublishNewProductViewController(type : NewType.newTypeProduct)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let dict = self.rows.objectAtIndex(indexPath.row) as? NSDictionary
        let title = dict?["title"] as? String
        
        if title != nil {
            return 50
        } else {
            return 15
        }
        
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.rows.count
//        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        //        cell.textLabel?.text = "Row # \(indexPath.row)"
        //        return cell
        let mycell : ZXProfileCell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ZXProfileCell
        mycell.dict = self.rows.objectAtIndex(indexPath.row) as? NSDictionary
        
        return mycell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dict = self.rows.objectAtIndex(indexPath.row) as? NSDictionary
        let title = dict?["title"] as? String
        
        if title == "账号管理" {
            
            if LoginedUser.sharedInstance.userID <= 0 {
                let loginViewcontroller = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
                let navi = UINavigationController(rootViewController: loginViewcontroller)
                navi.navigationBar.hidden = true
                self.presentViewController(navi, animated: true, completion: {
                    
                })
            } else {
                let controller = ZXAccountManagerViewController(nibName: "ZXAccountManagerViewController", bundle: nil)
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
        } else if title == "意见反馈" {
            let controller = ZXFeedbackViewController(nibName: "ZXFeedbackViewController", bundle: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        } else if title == "关于我们" {
            let controller = ZXAboutViewController(nibName: "ZXAboutViewController", bundle: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        } else if title == "版本更新" {
//            NSString *urlPath = [NSString stringWithFormat: @"https://itunes.apple.com/us/app/apple-store/id%@?mt=8", appId];
//            return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlPath]];
            
            let url = "https://itunes.apple.com/us/app/apple-store/id%@?mt=8"
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        } else if title == "我的主页" {
            
            if LoginedUser.sharedInstance.userID <= 0 {
                let loginViewcontroller = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
                let navi = UINavigationController(rootViewController: loginViewcontroller)
                navi.navigationBar.hidden = true
                self.presentViewController(navi, animated: true, completion: {
                    
                })
            } else {
                let controller = ZXPersonViewController(nibName: "ZXPersonViewController", bundle: nil)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func registerButtonPressed() {
        
        let controller = ZXAccountLoginViewController(nibName: "ZXAccountLoginViewController", bundle: nil)
        controller.loType = LoginType.LoginTypeLogin
        
        if self.navigationController != nil {
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    func avatarButtonPressed() {
        let controller = ZXPersonViewController(nibName: "ZXPersonViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func loginSuccess() {
        self.headerView.user = LoginedUser.sharedInstance
    }
    
    func logoutSuccess() {
        self.headerView.user = LoginedUser.sharedInstance
    }
}
