//
//  ZXProductDetailViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/13.
//  Copyright © 2016年 Zhixin. All rights reserved.
//


//#用户评论产品接口
//接口：
//http://test.npinfang.com/post/item/comment
//参数（POST请求）：适用于android版app
//#pno=1,  产品编号
//#content=content,  评论内容
//说明：用户评论产品，需要用户处于登录状态；
//#
//返回数据（Json）：
//{"code":200,"msg":"success"}
//{"code":401,"msg":"data not valid"}
//{"code":200,"msg":"success","data":{"cno":16,"pno":1,"uno":1,"content":"1223455","state":1,"time":1455874165000,"user":{"uno":1,"nick":"nick2","icon":"http://test.npinfang.com/res/image/M014543125720005.jpg","work":"work2","desc":"desc1"}}}


import UIKit
import Alamofire

class ZXProductDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scroll : UIScrollView?
    @IBOutlet var naviView : UIView?
    @IBOutlet var back : UIView?
    @IBOutlet var tLabel : UILabel?
    var indicator : UIView!
    var news : ZXNews?
    var infoButton : UIButton!
    var linkButton : UIButton!
    var webView : UIWebView?
    var shareView : ZXShareView?
    
    var bar : ZXProductCommentBar?
    
    var tableViewController : ZXProductDetailTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.hidden = true
        self.naviView?.backgroundColor = Colors.navigationColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZXProductDetailViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ZXProductDetailViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.infoButton = UIButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width / 2, 35))
        self.infoButton.setTitle("产品", forState: UIControlState.Normal)
        self.infoButton.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.infoButton.setTitleColor(Colors.navigationColor(), forState: UIControlState.Selected)
        self.back?.addSubview(self.infoButton)
        self.infoButton.addTarget(self, action: #selector(ZXProductDetailViewController.infoButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.infoButton.selected = true;
        
        self.linkButton = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width / 2, 0, UIScreen.mainScreen().bounds.size.width / 2, 35))
        self.linkButton.setTitle("官网", forState: UIControlState.Normal)
        self.linkButton.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.linkButton.setTitleColor(Colors.navigationColor(), forState: UIControlState.Selected)
        self.back?.addSubview(self.linkButton)
        self.linkButton.addTarget(self, action: #selector(ZXProductDetailViewController.linkButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.linkButton.selected = false
        
        self.indicator = UIView(frame: CGRectMake(0, (back?.frame.size.height)! - 3, UIScreen.mainScreen().bounds.size.width / 2, 3))
        self.indicator.backgroundColor = Colors.navigationColor()
        self.back?.addSubview(self.indicator!)
        
        self.scroll?.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width * 2, (self.scroll?.frame.size.height)!)
        self.scroll?.pagingEnabled = true
        self.scroll?.backgroundColor = UIColor.clearColor()
        self.scroll?.delegate = self;
        
        self.webView = UIWebView(frame: CGRectMake((self.scroll?.contentSize.width)! / 2, 1, (self.scroll?.contentSize.width)! / 2, UIScreen.mainScreen().bounds.size.height - 100))
        self.scroll?.addSubview(self.webView!)
        
        let url = NSURL (string: (self.news?.link)!);
        let requestObj = NSURLRequest(URL: url!);
        self.webView?.loadRequest(requestObj);
        
        self.tableViewController = ZXProductDetailTableViewController()
        self.tableViewController?.news = self.news
        self.scroll?.addSubview((self.tableViewController?.tableView)!)
        var rect2 = self.tableViewController?.tableView.frame
        rect2?.size.width = self.view.frame.size.width
        self.tableViewController?.tableView.frame = rect2!
        
        self.bar = NSBundle.mainBundle().loadNibNamed("ZXProductCommentBar", owner: nil, options: nil)[0] as? ZXProductCommentBar
        self.bar?.autoresizingMask = UIViewAutoresizing.None
        var rect = bar?.frame
        rect?.origin.y = self.view.frame.size.height + 54
        rect?.size.width = UIScreen.mainScreen().bounds.size.width
        self.bar?.frame = rect!
        self.view.addSubview(self.bar!)
        self.bar?.button?.addTarget(self, action: #selector(ZXProductDetailViewController.commentButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tLabel?.text = self.news?.title
        
        self.shareView = ZXShareView( frame: UIScreen.mainScreen().bounds)
//        self.view.addSubview(self.shareView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                var rect = bar?.frame
                rect?.origin.y = self.view.frame.size.height - keyboardSize.height - 44
//                rect?.origin.y = 200
                rect?.size.width = UIScreen.mainScreen().bounds.size.width
                self.bar?.frame = rect!
                // ...
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //
        var rect = bar?.frame
        rect?.origin.y = self.view.frame.size.height - 44
        rect?.size.width = UIScreen.mainScreen().bounds.size.width
        self.bar?.frame = rect!
    }

    
    func infoButtonPressed(sender : UIButton) {
        self.infoButton.selected = true
        self.linkButton.selected = false
        
        UIView.animateWithDuration(0.2) {
            self.indicator.frame = CGRectMake(0, 32, UIScreen.mainScreen().bounds.size.width / 2, 3)
            
            self.scroll?.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func linkButtonPressed(sender : UIButton) {
        self.infoButton.selected = false
        self.linkButton.selected = true
        
        UIView.animateWithDuration(0.2) {
            self.indicator.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width / 2, 32, UIScreen.mainScreen().bounds.size.width / 2, 3)
            
            self.scroll?.setContentOffset(CGPointMake(UIScreen.mainScreen().bounds.size.width, 0), animated: true)
        }
    }
    
    func commentButtonPressed(sender : UIButton) {
        
        let paras = ["pno" : String((self.news?.pNo)!), "content" : (self.bar?.filed?.text)!]
        
        Alamofire.request(.POST, "http://www.npinfang.com/post/item/comment", parameters: paras).responseJSON(completionHandler: { (response) in
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //                print("the Json is \(JSON)")
                print("so the data is \(JSON["data"]!)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    let data = JSON["data"] as? NSDictionary
                    
                    let comm : ZXProductComment = ZXProductComment(dict: NSDictionary())
                    comm.avatar = LoginedUser.sharedInstance.avatar
                    comm.nickName = LoginedUser.sharedInstance.nickName
                    comm.date = "刚刚"
                    comm.content = self.bar?.filed?.text
                    
                    self.tableViewController?.comments.addObject(comm)
                    self.tableViewController?.tableView.reloadData()
                    
                    self.bar?.filed?.resignFirstResponder()
                    self.bar?.filed?.text = ""
                    
                } else {
                    
                }
                
            } catch {
                
            }
        })
    }
    
    @IBAction func backButtonPress(sender : AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shareButtonPress(sender : AnyObject) {
        
        self.view.addSubview(self.shareView!)
        self.shareView?.show()
    }
    
    @IBAction func addButtonPress(sender : AnyObject) {
        
        let controller = ZXPublishNewProductViewController(type: NewType.newTypeProduct)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = (self.scroll?.contentOffset.x)! / (self.scroll?.frame.size.width)!
        
        if index == 0 {
            self.indicator.frame = CGRectMake(0, 32, self.view.frame.size.width / 2, 3)
            self.infoButton.selected = true
            self.linkButton.selected = false
        } else {
            self.indicator.frame = CGRectMake(self.view.frame.size.width / 2, 32, self.view.frame.size.width / 2, 3)
            self.infoButton.selected = false
            self.linkButton.selected = true
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var rect = self.indicator.frame
        rect.origin.x = scrollView.contentOffset.x / 2
        self.indicator.frame = rect
        
        self.bar?.filed?.resignFirstResponder()
    }
}
