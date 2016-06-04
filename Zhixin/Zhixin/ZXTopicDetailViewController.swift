//
//  ZXTopicDetailViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

class ZXTopicDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var news : NSMutableArray!
    var tableView : UITableView!
    var maskView : ZXTopicMaskView?
    @IBOutlet var navigationView : UIView?
    @IBOutlet var favoButton : UIButton?
    var shareView : ZXShareView!
    var topic : ZXTopic?
    var pages : NSInteger?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        self.news = NSMutableArray()
        
        self.shareView = ZXShareView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300))
//        self.view.addSubview(self.shareView)

        // Do any additional setup after loading the view.
        self.tableView = UITableView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 64))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "ZXNewsTableViewCell", bundle:nil), forCellReuseIdentifier: "newsCell")
        self.view.addSubview(self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.hidden = true
        
        
        self.maskView = ZXTopicMaskView(frame: UIScreen.mainScreen().bounds)
        self.view.insertSubview(self.maskView!, belowSubview: self.navigationView!)
        self.navigationView?.backgroundColor = UIColor.clearColor()
        self.maskView?.topic = self.topic
        
        self.favoButton?.hidden = true
        
        var panGesture = UIPanGestureRecognizer(target: self, action:#selector(ZXTopicDetailViewController.handlePanGesture(_:)))
        self.maskView!.addGestureRecognizer(panGesture)
        
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(ZXTopicsTableViewController.refreshDatas))
        
        self.tableView.headerView?.beginRefreshing()
        self.tableView.headerView?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        
        var translation  = panGesture.translationInView(self.view)
        if translation.y > 0 {
            return
        }
        self.maskView?.center = CGPointMake((self.maskView?.center.x)!, self.view.center.y + translation.y)
        
        if panGesture.state == UIGestureRecognizerState.Ended {
            if self.maskView?.center.y < self.view.frame.size.height / 4 {
                
                let rect = CGRectMake(0, -(self.maskView?.frame.size.height)!, (self.maskView?.frame.size.width)!, (self.maskView?.frame.size.height)!)
                UIView.animateWithDuration(0.2, animations: {
                    self.maskView?.frame = rect
                    }, completion: { (finished) in
                        self.maskView?.removeFromSuperview()
                        self.navigationView?.backgroundColor = Colors.navigationColor()
                        self.favoButton?.hidden = false
                        self.tableView.hidden = false
                })
                
            } else {
                
                let rect = CGRectMake(0, 0, (self.maskView?.frame.size.width)!, (self.maskView?.frame.size.height)!)
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.maskView?.frame = rect
                    }, completion: { (finished) in
                        
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell : ZXNewsTableViewCell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! ZXNewsTableViewCell
        mycell.nameLabel.text = "Row # \(indexPath.row)"
        
        return mycell
    }
    
    func refreshDatas() {
        
        self.pages = 1
        
        var  paras : [String:AnyObject] = ["tno":"1"]
        
        let num = (self.topic?.topicNo!)! as NSNumber
        
        paras = ["tno" : num]
        
        Alamofire.request(.POST, "http://www.npinfang.com/apps/topic/item/list", parameters: paras).responseJSON(completionHandler: { (response) in
            //            print("the response is \(response)")
            
            self.tableView.headerView?.endRefreshing()
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //                print("the Json is \(JSON)")
                print("so the data is \(JSON["data"]!)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    
                    self.news?.removeAllObjects()
                    
                    let data = JSON["data"]
                    let list = data!!["list"]! as? NSArray
                    
                    if list != nil {
                        for dict in list! {
                            
                            let topic = ZXNews(dict: dict as! NSDictionary)
                            self.news?.addObject(topic)
                        }
                    }
                    self.tableView.reloadData()
                    if self.news?.count <= 0 {
                        self.view.makeToast(message: "暂无数据");
                    }
                    
                } else {
                    self.view.makeToast(message: "服务器故障")
                }
                
            } catch {
                
            }
        })
    }
    
    @IBAction func backButtonPressed(sender : AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func favoButtonPressed(sender : AnyObject) {
        
        let paras = ["tno" : String(self.topic?.topicNo)]
        
        if self.topic?.favoed == true {
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/lose/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                //            print("the response is \(response)")
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if response.response?.statusCode == 200 {
                        
                        self.favoButton?.backgroundColor = UIColor.clearColor()
                        self.topic?.favoed = false
                        self.favoButton?.tintColor = UIColor.whiteColor();
                        self.view.makeToast(message: "操作成功")
                        
                    } else {
                        // 登录
                        print("等录取")
                        let login  = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
                        self.view.makeToast(message: "请重新登录")
                    }
                    
                } catch {
                    
                }
            })
            
        } else {
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/gain/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                //            print("the response is \(response)")
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    if response.response?.statusCode == 200 {
                        
                        self.favoButton?.backgroundColor = Colors.navigationColor()
                        self.topic?.favoed = true
                        self.view.makeToast(message: "收藏成功")
                        self.favoButton?.tintColor = UIColor.redColor()
                        
                    } else {
                        // 登录
                        print("等录取")
                        self.view.makeToast(message: "请重新登录")
                    }
                    
                } catch {
                    
                }
            })
        }
    }
    
    @IBAction func sharebuttonPressed(sender: AnyObject) {
        
        //show shareview
    }
    
    @IBAction func addButtonPressed(sender : AnyObject) {
        
        let controller = ZXPublishNewProductViewController(type: NewType.newTypeProduct)
        controller.toTopic = self.topic
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
