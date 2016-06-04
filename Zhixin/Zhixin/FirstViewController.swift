//
//  FirstViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/9.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var tableview : UITableView?
    var news : NSMutableArray?
    var dates : NSMutableArray?
    var navigationView : UIView!
    var icon : UIImageView!
    var searchButton : UIButton!
    var dateButton : UIButton!
    var pages : NSInteger?
//    var totalPages : NSInteger?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationView = UIView(frame: CGRectMake(0, 0, self.view!.frame.size.width, 64))
        self.navigationView.backgroundColor = Colors.navigationColor()
        
        self.icon = UIImageView(frame: CGRectMake(15, 25, 30, 30))
        self.icon.backgroundColor = UIColor.clearColor()
        self.icon.contentMode = UIViewContentMode.ScaleAspectFit
        self.icon.image = UIImage(named: "nIcon")
        self.navigationView.addSubview(self.icon)
        
        self.searchButton = UIButton(frame: CGRectMake(self.view.frame.size.width - 120, 12, 54, 54))
        self.searchButton.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        self.searchButton.addTarget(self, action: #selector(FirstViewController.searchButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationView.addSubview(self.searchButton)
        
        self.dateButton = UIButton(frame: CGRectMake(self.view.frame.size.width - 60, 12, 54, 54))
        self.dateButton.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        self.dateButton.addTarget(self, action: #selector(FirstViewController.dateButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationView.addSubview(self.dateButton)
        
        self.news = NSMutableArray(capacity: 0)
        self.dates = NSMutableArray()
        
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        self.tableview?.registerNib(UINib(nibName: "ZXNewsTableViewCell", bundle:nil), forCellReuseIdentifier: "newsCell")
        self.view.addSubview(self.tableview!)
        self.tableview?.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        self.tableview?.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableview?.headerView = XWRefreshNormalHeader(target: self, action: #selector(FirstViewController.refreshDatas))
        self.tableview?.headerView?.beginRefreshing()
        self.tableview?.headerView?.endRefreshing()
        
        self.tableview?.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(ZXTopicsTableViewController.loadMoreDatas))
        self.view.addSubview(self.navigationView)
        
        self.tableview?.headerView?.beginRefreshing()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        return 30
        let realNews = self.news![section] as! NSArray
        return realNews.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.news?.count)!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ZXDateHeaderView(frame: CGRectMake(0, 0, self.view.frame.size.width, 35))
        var str = self.dates![section] as! String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.dateFromString(str)
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let stt = dateFormatter.stringFromDate(date!)
        view.dateLabel?.text = stt
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

        let mycell : ZXNewsTableViewCell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! ZXNewsTableViewCell
        mycell.nameLabel.text = "Row # \(indexPath.row)"
        mycell.news = self.news!.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? ZXNews;
        
        return mycell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let news = self.news?.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? ZXNews
        let controller = ZXProductDetailViewController(nibName: "ZXProductDetailViewController", bundle: nil)
        controller.news = news
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchButtonPressed(sender : UIButton) {
        print("search!")
        let controller = ZXSearchViewController(nibName: "ZXSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func dateButtonPressed(sender : UIButton) {
        if LoginedUser.sharedInstance.userID <= 0 {
            let loginViewcontroller = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
            let navi = UINavigationController(rootViewController: loginViewcontroller)
            navi.navigationBar.hidden = true
            self.presentViewController(navi, animated: true, completion: {
                
            })
        } else {
            
            let controller = ZXPublishNewProductViewController(type: NewType.newTypeProduct)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func loadMoreDatas() {
        
        if self.tableview!.headerView?.isRefreshing == true {
            self.tableview?.footerView?.endRefreshing()
            return
        }
        
        self.pages = 1 + self.pages!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.dateFromString((self.dates?.lastObject)! as! String)
        let preDate = date?.dateByAddingTimeInterval(-24 * 60 * 60)
        let stt = dateFormatter.stringFromDate(preDate!)
        
        let num = self.pages! as NSNumber
        
        let paras = ["page" : num,
                     "rows" : "15",
                     "day" : stt,
                     ]//"dn" : "1"
        
        Alamofire.request(.POST, "http://www.npinfang.com/apps/item/list", parameters: paras).responseJSON(completionHandler: { (response) in
            //            print("the response is \(response)")
            
            self.tableview?.headerView?.endRefreshing()
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //                print("the Json is \(JSON)")
                print("so the data is \(JSON)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    
//                    self.news?.removeAllObjects()
                    
                    let data = JSON["data"] as! NSArray
                    for dict in data {
                        
                        self.dates?.addObject((dict["day"] as? String)!)
                        var realNews = NSMutableArray()
                        
                        print( "the dict is \(dict)")
                        
                        let rawNs = dict["list"] as? NSArray
                        
                        if rawNs != nil {
                            for rawN in (rawNs)! {
                                let newsss = ZXNews(dict : rawN as! NSDictionary)
                                realNews.addObject(newsss)
                            }
                        }
                        
                        self.news?.addObject(realNews)
                    }
                    
                    self.tableview?.reloadData()
                    self.tableview?.footerView?.endRefreshing()
                    
                } else {
                    self.view.makeToast(message: "服务器故障")
                    self.tableview?.footerView?.endRefreshing()
                }
                
            } catch {
                
            }
        })
        
        
    }
    
    func refreshDatas() {
        
        if self.tableview!.footerView?.isRefreshing == true {
            self.tableview!.headerView?.endRefreshing()
            return
        }
        
        self.pages = 1
        
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyyMMdd"
        var nowString = dateFormatter2.stringFromDate(NSDate())
        
        let num = self.pages! as NSNumber
        
        let paras = ["page" : num,
                 "rows" : "15",]
        
        Alamofire.request(.POST, "http://www.npinfang.com/apps/item/list", parameters: paras).responseJSON(completionHandler: { (response) in
            //            print("the response is \(response)")
            
            self.tableview?.headerView?.endRefreshing()
            
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                //                print("the Json is \(JSON)")
                print("so the data is \(JSON)")
                
                let code = JSON["code"]!!.integerValue
                if code == 200 {
                    
                    self.news?.removeAllObjects()
                    
                    let data = JSON["data"] as! NSArray
                    for dict in data {
                        
                        self.dates?.addObject((dict["day"] as? String)!)
                        var realNews = NSMutableArray()
                        
                        print( "the dict is \(dict)")
                        
                        let rawNs = dict["list"] as? NSArray
                        
                        if rawNs != nil {
                            for rawN in (rawNs)! {
                                let newsss = ZXNews(dict : rawN as! NSDictionary)
                                realNews.addObject(newsss)
                            }
                        }
                    
                        self.news?.addObject(realNews)
                    }
                    
                    self.tableview?.reloadData()
                    
                } else {
                    self.view.makeToast(message: "服务器故障")
                }
                
            } catch {
                print ("response is \(response)")
            }
        })
    }
}

