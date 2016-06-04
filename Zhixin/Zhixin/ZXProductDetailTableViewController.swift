//
//  ZXProductDetailTableViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/13.
//  Copyright © 2016年 Zhixin. All rights reserved.
//
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

class ZXProductDetailTableViewController: UITableViewController {
    
    var headerView : ZXProductDetaiHeaderView!
    var comments : NSMutableArray!
    var news : ZXNews?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.comments = NSMutableArray(capacity: 0)
        
        self.headerView = NSBundle.mainBundle().loadNibNamed("ZXProductDetaiHeaderView", owner: nil, options: nil)[0] as! ZXProductDetaiHeaderView
        self.headerView.autoresizingMask = UIViewAutoresizing.None
        self.headerView.news = self.news
        self.headerView.clipsToBounds = true
        
        self.tableView.registerNib(UINib(nibName: "ZXProductCommentCell", bundle:nil), forCellReuseIdentifier: "commentCell")
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.refresh()
        
        self.headerView.getPersons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.comments.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell : ZXProductCommentCell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! ZXProductCommentCell
//        mycell.des!.text = "Row # \(indexPath.row)"
        mycell.comment = self.comments[indexPath.row] as? ZXProductComment
        
        return mycell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let comm = self.comments[indexPath.row] as? ZXProductComment
        return 47 + (comm?.content?.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 66, font: UIFont.systemFontOfSize(13.0)))!
    }
    
    func refresh() {
        
        let paras = ["pno" : String((self.news?.pNo)!), "page" : "1", "rows" : "30"]
        
        Alamofire.request(.POST, "http://www.npinfang.com/scan/item/comment", parameters: paras).responseJSON(completionHandler: { (response) in
            //            print("the response is \(response)")
            
            //            self.tableview?.headerView?.endRefreshing()
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //                print("the Json is \(JSON)")
                print("so the data is \(JSON)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    
                    self.comments?.removeAllObjects()
                    
                    let data = JSON["data"] as! NSDictionary
                    let list = data["list"] as? NSArray
                    self.headerView.commentsLabel?.text = String(data["total"]!) + "条评论"
                    
                    if list != nil {
                        for dict in list! {
                            
                            var comment = ZXProductComment(dict: dict as! NSDictionary)
                            self.comments.addObject(comment)
                        }
                    }
                    
                    self.headerView.commentsLabel?.text = String(self.comments.count) + "条评论"
                    
                    if self.comments.count == 0 {
                        self.headerView.commentsLabel?.hidden = true
                    } else {
                        self.headerView.commentsLabel?.hidden = false
                    }
                    self.tableView?.reloadData()
                    
                } else {
                    self.view.makeToast(message: "服务器故障")
                }
                
            } catch {
                print ("response is \(response)")
            }
        })
    }
}
