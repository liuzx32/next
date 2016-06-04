//
//  ZXTopicsTableViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

enum TopicType {
    case topicTypeNewest
    case topicTypeHotest
    case topicTypeSearch
    case topicTypePerson
}

protocol topicsTableViewControllerDelegate {
    func topicsTableViewControllerDidScroll(sender : ZXTopicsTableViewController)
    func topicsTableViewControllerDidSelectTopic(topic: ZXTopic?)
}

class ZXTopicsTableViewController: UITableViewController {
    
    var type : TopicType!
    var delegate : topicsTableViewControllerDelegate?
    var pages : NSInteger?
    var totalPages : NSInteger?
    var topics : NSMutableArray?
    var searchingWord : String?
    
    init(style: UITableViewStyle, type : TopicType) {
    
        super.init(style : style)
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pages = 1;
        self.topics = NSMutableArray()
        
        self.tableView.registerNib(UINib(nibName: "ZXTopicCell", bundle:nil), forCellReuseIdentifier: "topicCell")
        
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(ZXTopicsTableViewController.refreshDatas))
        
        self.tableView.headerView?.beginRefreshing()
        self.tableView.headerView?.endRefreshing()
        
        self.tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(ZXTopicsTableViewController.loadMoreDatas))
        
        self.tableView.headerView?.beginRefreshing()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refreshDatas() {
        
        if self.tableView.footerView?.isRefreshing == true {
            self.tableView.headerView?.endRefreshing()
            return
        }
        
        self.pages = 1
        
        var  paras: [String:AnyObject] = ["one":"1"]
        
        let num = self.pages! as NSNumber
        
        if self.type == TopicType.topicTypeNewest {
             paras = ["page" : num,
                     "rows" : "15",
                     "type" : "new",]
            
            print("the newest")
        } else if self.type == TopicType.topicTypeHotest {
            paras = ["page" : num,
                     "rows" : "15",
                     "type" : "hot",]
            print("the hotest")
        } else if self.type == TopicType.topicTypeSearch {
            
            if self.searchingWord?.characters.count > 0 {
                paras = ["page" : num,
                         "term" : self.searchingWord!,
                         "rows" : "15",]
                
                Alamofire.request(.POST, "http://www.npinfang.com/apps/search/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                    //            print("the response is \(response)")
                    
                    self.tableView.headerView?.endRefreshing()
                    
                    do {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                        //                print("the Json is \(JSON)")
                        print("so the data is \(JSON["data"]!)")
                        
                        let code = JSON["code"]!!.integerValue
                        if code == 200 {
                            
                            self.topics?.removeAllObjects()
                            
                            let data = JSON["data"]
                            let list = data!!["list"]! as! NSArray
                            for dict in list {
                                
                                let topic = ZXTopic(dict: dict as! NSDictionary)
                                self.topics?.addObject(topic)
                            }
                            
                            self.tableView.reloadData()
                            
                        } else {
                            self.view.makeToast(message: "服务器故障")
                        }
                        
                    } catch {
                        
                    }
                })
                
            } else {
                
                self.tableView.headerView?.endRefreshing()
            }
            
            return
        }
        
        Alamofire.request(.POST, "http://www.npinfang.com/apps/topic/list", parameters: paras).responseJSON(completionHandler: { (response) in
//            print("the response is \(response)")
            
            self.tableView.headerView?.endRefreshing()
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
//                print("the Json is \(JSON)")
//                print("so the data is \(JSON["data"]!)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    
                    self.topics?.removeAllObjects()
                    
                    let data = JSON["data"]
                    let list = data!!["list"]! as! NSArray
                    let pages = data!!["pages"] as? NSNumber
                    self.totalPages = pages?.integerValue
                    for dict in list {
                        print("the dict is \(dict)")
                        let topic = ZXTopic(dict: dict as! NSDictionary)
                        self.topics?.addObject(topic)
                    }
                    
                    self.tableView.reloadData()
                    
                } else {
                    self.view.makeToast(message: "服务器故障")
                }
                
            } catch {
                
            }
        })
    }
    
    func loadMoreDatas() {
    
        if self.tableView.headerView?.isRefreshing == true {
            self.tableView.footerView?.endRefreshing()
            return
        }
        
        self.pages = self.pages! + 1
        
        if self.pages > self.totalPages {
            self.pages = self.pages! - 1
            self.tableView.footerView?.endRefreshing()
            return
        }
        
        var  paras: [String:AnyObject] = ["one":"1"]
        
        let num = self.pages! as NSNumber
        
        if self.type == TopicType.topicTypeNewest {
            paras = ["page" : num,
                     "rows" : "15",
                     "type" : "new",]
            
            print("the newest")
        } else if self.type == TopicType.topicTypeHotest {
            paras = ["page" : num,
                     "rows" : "15",
                     "type" : "hot",]
            print("the hotest")
        } else if self.type == TopicType.topicTypeSearch {
            
            if self.searchingWord?.characters.count > 0 {
                paras = ["page" : num,
                         "term" : self.searchingWord!,
                         "rows" : "15",]
                
                Alamofire.request(.POST, "http://www.npinfang.com/apps/search/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                    //            print("the response is \(response)")
                    
                    self.tableView.footerView?.endRefreshing()
                    
                    do {
                        let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                        //                print("the Json is \(JSON)")
                        print("so the data is \(JSON["data"]!)")
                        
                        let code = JSON["code"]!!.integerValue
                        if code == 200 {
                            
                            let data = JSON["data"]
                            let list = data!!["list"]! as! NSArray
                            
                            for dict in list {
                                
                                let topic = ZXTopic(dict: dict as! NSDictionary)
                                self.topics?.addObject(topic)
                            }
                            
                            self.tableView.reloadData()
                            
                        } else {
                            self.view.makeToast(message: "服务器故障")
                        }
                        
                    } catch {
                        
                    }
                })
                
            }
            
            return
        }
        
        Alamofire.request(.POST, "http://www.npinfang.com/apps/topic/list", parameters: paras).responseJSON(completionHandler: { (response) in
            //            print("the response is \(response)")
            
            self.tableView.footerView?.endRefreshing()
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //                print("the Json is \(JSON)")
                                print("so the data is \(JSON["data"]!)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    
                    let data = JSON["data"]
                    let list = data!!["list"]! as! NSArray
                    for dict in list {
                        
                        let topic = ZXTopic(dict: dict as! NSDictionary)
                        self.topics?.addObject(topic)
                    }
                    
                    self.tableView.reloadData()
                    
                } else {
                    self.view.makeToast(message: "服务器故障")
                }
                
            } catch {
                
            }
        })
        
        print("loadmore!!!")
    }
    
    func startSearchWith(word: String) {
        
//        http://test.npinfang.com/apps/search/topic
//        参数（POST请求）：适用于app
//        term=O2O,  其中term为用户查询的关键词，按照用户输入关键词查询；
//        page=1,  数据较多时的分页页码；
//        rows=15,  分页时每页显示的条目数量；

        
        if self.type == TopicType.topicTypeSearch {
            
            self.searchingWord = word
            
            self.pages = 1
            
            let num = self.pages! as NSNumber
            
            let paras = ["page" : num,
                         "term" : word,
                         "rows" : "15",]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/search/topic", parameters: paras).responseJSON(completionHandler: { (response) in
                //            print("the response is \(response)")
                
                self.tableView.headerView?.endRefreshing()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    self.topics?.removeAllObjects()
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        
                        //                    UIApplication.sharedApplication().keyWindow?.makeToast(message: "修改成功")
                        self.navigationController?.popViewControllerAnimated(true)
                        
                        let data = JSON["data"]
                        let pages = data!!["pages"] as? NSNumber
                        self.totalPages = pages?.integerValue
                        
                        if self.totalPages == 0 {
                            self.view.makeToast(message: "暂无搜索结果")
                            return
                        }
                        let list = data!!["list"] as? NSArray
                        
                        if list != nil {
                            for dict in list! {
                                
                                let topic = ZXTopic(dict: dict as! NSDictionary)
                                self.topics?.addObject(topic)
                            }
                        }
                        
                        
                        self.tableView.reloadData()
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                    }
                    
                } catch {
                    
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.delegate?.topicsTableViewControllerDidScroll(self)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.topics?.count)!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 145
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell : ZXTopicCell = tableView.dequeueReusableCellWithIdentifier("topicCell", forIndexPath: indexPath) as! ZXTopicCell
//        mycell.nameLabel.text = "Row # \(indexPath.row)"
        mycell.topic = self.topics![indexPath.row] as? ZXTopic
        
        return mycell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let topic = self.topics![indexPath.row] as? ZXTopic
        
        let viewController = ZXTopicDetailViewController(nibName: "ZXTopicDetailViewController", bundle: nil)
        viewController.topic = topic
        self.navigationController?.pushViewController(viewController, animated: true)
        
        self.delegate?.topicsTableViewControllerDidSelectTopic(topic)
    }
}
