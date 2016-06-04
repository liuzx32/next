//
//  ZXProductsTableViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/16.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

enum productsType {
    case zans
    case publishes
    case search
}

import UIKit
import Alamofire

protocol productsTableViewControllerDelegate {
    func productsTableViewControllerDidScroll(sender : ZXProductsTableViewController)
    func productsTableViewControllerDidSelectProduct(product: ZXNews?)
}

class ZXProductsTableViewController: UITableViewController {
    
    var products : NSMutableArray?
    var productType : productsType?
    var delegate : productsTableViewControllerDelegate?
    var pages : NSInteger?
    var totalPages : NSInteger?
    
    var date : String?
    var term : String?
    
//    init(style: UITableViewStyle, type : productsType) {
//        
//        self.productType = type
//        super.init(style : style)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.products = NSMutableArray(capacity: 0)
        
        self.tableView.registerNib(UINib(nibName: "ZXNewsTableViewCell", bundle:nil), forCellReuseIdentifier: "newsCell")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView?.headerView = XWRefreshNormalHeader(target: self, action: #selector(FirstViewController.refreshDatas))
        self.tableView?.headerView?.beginRefreshing()
        self.tableView?.headerView?.endRefreshing()
        
        self.tableView?.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(ZXTopicsTableViewController.loadMoreDatas))

    }
    
    func startSearching(term : String, date : String?) {
        
        self.term = term
        self.date = date
        
        self.tableView.headerView?.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.delegate?.productsTableViewControllerDidScroll(self)
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 71
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return (self.products?.count)!
        return (self.products?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell : ZXNewsTableViewCell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! ZXNewsTableViewCell
        mycell.nameLabel.text = "Row # \(indexPath.row)"
        mycell.news = self.products![indexPath.row] as? ZXNews
        
        return mycell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let news = self.products![indexPath.row] as? ZXNews
        self.delegate?.productsTableViewControllerDidSelectProduct(news)
    }

    func refreshDatas() {
        
        if self.tableView.footerView?.isRefreshing == true {
            self.tableView.headerView?.endRefreshing()
            return
        }
     
        self.pages = 1
        
        var  paras: [String:AnyObject] = ["one":"1"]
        
        let num = self.pages! as NSNumber
        
        if self.productType == productsType.search {
            
            paras = ["page" : num,
                     "rows" : "15",]
            
            if self.term?.characters.count > 0 {
                paras["term"] = self.term!
                if self.date?.characters.count > 0 {
                    paras["date"] = self.date!
                }
            }
            
            if self.term?.characters.count <= 0 && self.date?.characters.count <= 0 {
                self.tableView.headerView?.endRefreshing()
                return
            }
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/search/item", parameters: paras).responseJSON(completionHandler: { (response) in
                self.tableView.headerView?.endRefreshing()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        self.products?.removeAllObjects()
                        
                        let data = JSON["data"]
                        self.totalPages = data!!["pages"] as? NSInteger
                        let list = data!!["list"]! as! NSArray
                        for dict in list {
                            
                            let topic = ZXNews(dict: dict as! NSDictionary)
                            self.products?.addObject(topic)
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                    }
                    
                    self.tableView.headerView?.endRefreshing()
                    
                } catch {
                    
                }
            })
            
        } else if self.productType == productsType.zans {
            
            paras = ["page" : num,
                     "rows" : "15",]
            
            Alamofire.request(.POST, "http://www.npinfang.com/take/user/vote/item", parameters: paras).responseJSON(completionHandler: { (response) in
                self.tableView.headerView?.endRefreshing()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        self.products?.removeAllObjects()
                        
                        let data = JSON["data"]
                        self.totalPages = data!!["pages"] as? NSInteger
                        let list = data!!["list"]! as! NSArray
                        for dict in list {
                            
                            let topic = ZXNews(dict: dict as! NSDictionary)
                            self.products?.addObject(topic)
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                    }
                    
                    self.tableView.headerView?.endRefreshing()
                } catch {
                    
                }
            })
        } else if self.productType == productsType.publishes {
            
            paras = ["page" : num,
                     "rows" : "15",]
            
            Alamofire.request(.POST, "http://test.npinfang.com/take/user/item", parameters: paras).responseJSON(completionHandler: { (response) in
                self.tableView.headerView?.endRefreshing()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        self.products?.removeAllObjects()
                        
                        let data = JSON["data"]
                        self.totalPages = data!!["pages"] as? NSInteger
                        let list = data!!["list"]! as! NSArray
                        for dict in list {
                            
                            let topic = ZXNews(dict: dict as! NSDictionary)
                            self.products?.addObject(topic)
                        }
                        
                        self.tableView.reloadData()
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                    }
                    
                    self.tableView.headerView?.endRefreshing()
                } catch {
                    
                }
            })
        }
    }
    
    func loadMoreDatas() {
        
        if (self.totalPages)! <= (self.pages)! {
            return
        }
        
        if self.tableView.headerView?.isRefreshing == true {
            return
        }
        
        self.pages = 1 + self.pages!
        
        var  paras: [String:AnyObject] = ["one":"1"]
        
        let num = self.pages! as NSNumber
        
        if self.productType == productsType.search {
            
            paras = ["page" : num,
                     "rows" : "15",]
            
            if self.term?.characters.count > 0 {
                paras["term"] = self.term!
                if self.date?.characters.count > 0 {
                    paras["date"] = self.date!
                }
            }
            
            if self.term?.characters.count <= 0 && self.date?.characters.count <= 0 {
                self.tableView.headerView?.endRefreshing()
                return
            }
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/search/item", parameters: paras).responseJSON(completionHandler: { (response) in
                self.tableView.headerView?.endRefreshing()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
//                        self.products?.removeAllObjects()
                        
                        let data = JSON["data"]
                        let list = data!!["list"]! as! NSArray
                        for dict in list {
                            
                            let topic = ZXNews(dict: dict as! NSDictionary)
                            self.products?.addObject(topic)
                        }
                        
                        self.tableView.reloadData()
                        self.tableView?.footerView?.endRefreshing()
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                        self.tableView?.footerView?.endRefreshing()
                    }
                    
                } catch {
                    
                }
            })
            
        } else if self.productType == productsType.zans {
            
            paras = ["page" : num,
                     "rows" : "15",]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/search/item", parameters: paras).responseJSON(completionHandler: { (response) in
                self.tableView.headerView?.endRefreshing()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        //                        self.products?.removeAllObjects()
                        
                        let data = JSON["data"]
                        let list = data!!["list"]! as! NSArray
                        for dict in list {
                            
                            let topic = ZXNews(dict: dict as! NSDictionary)
                            self.products?.addObject(topic)
                        }
                        
                        self.tableView.reloadData()
                        self.tableView?.footerView?.endRefreshing()
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                        self.tableView?.footerView?.endRefreshing()
                    }
                    
                } catch {
                    
                }
            })
        } else if self.productType == productsType.publishes {
            
            paras = ["page" : num,
                     "rows" : "15",]
            
            Alamofire.request(.POST, "http://test.npinfang.com/take/user/item", parameters: paras).responseJSON(completionHandler: { (response) in
                self.tableView.headerView?.endRefreshing()
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        
                        //                        self.products?.removeAllObjects()
                        
                        let data = JSON["data"]
                        let list = data!!["list"]! as! NSArray
                        for dict in list {
                            
                            let topic = ZXNews(dict: dict as! NSDictionary)
                            self.products?.addObject(topic)
                        }
                        
                        self.tableView.reloadData()
                        self.tableView?.footerView?.endRefreshing()
                        
                    } else {
                        self.view.makeToast(message: "服务器故障")
                        self.tableView?.footerView?.endRefreshing()
                    }
                    
                } catch {
                    
                }
            })
        }
    }
}
