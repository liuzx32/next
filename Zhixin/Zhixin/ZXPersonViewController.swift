//
//  ZXPersonViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/17.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher


class ZXPersonViewController: UIViewController, UIScrollViewDelegate, productsTableViewControllerDelegate, topicsTableViewControllerDelegate {
    
    var staleHeader : ZXProfileHeaderView!
    var zansTableView : ZXProductsTableViewController?
    var publishedTableView : ZXProductsTableViewController?
    var topicsTableView : ZXTopicsTableViewController?
    @IBOutlet var scroll : UIScrollView?
    @IBOutlet var navi : UIView?
    var stableSlider : UIView!
    var zanButton : UIButton?
    var pubButton : UIButton?
    var topButton : UIButton?
    var indicator : UIView!
    var displayingTable : UITableViewController?
    var user : ZXUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navi?.backgroundColor = Colors.navigationColor()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tabBarController?.tabBar.hidden = true
        
        self.scroll?.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width * 3, (self.scroll?.bounds.height)!)
        self.scroll?.delegate = self;
        self.scroll?.pagingEnabled = true
        
        self.staleHeader = NSBundle.mainBundle().loadNibNamed("ZXProfileHeaderView", owner: nil, options: nil)[0] as! ZXProfileHeaderView
        self.staleHeader.backgroundColor = Colors.navigationColor()
        self.staleHeader.autoresizingMask = UIViewAutoresizing.None
        self.view.addSubview(self.staleHeader)
        self.staleHeader.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, 172)
        
        self.zansTableView = ZXProductsTableViewController(style: UITableViewStyle.Plain)
        self.zansTableView?.productType = productsType.zans
        self.scroll?.addSubview((self.zansTableView?.view)!)
        self.zansTableView?.delegate = self
        self.zansTableView?.productType = productsType.zans
        self.zansTableView?.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, (self.scroll?.frame.size.height)!)
        self.zansTableView?.tableView.contentInset = UIEdgeInsetsMake(206, 0, 0, 0)
//        self.zansTableView?.tableView.tableHeaderView = self.zanHeader!
        
        self.publishedTableView = ZXProductsTableViewController(style: UITableViewStyle.Plain)
        self.publishedTableView?.productType = productsType.publishes
        self.scroll?.addSubview((self.publishedTableView?.view)!)
        self.publishedTableView?.delegate = self
        self.publishedTableView?.productType = productsType.publishes
        self.publishedTableView?.view.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, (self.scroll?.bounds.height)!)
        self.publishedTableView?.tableView.contentInset = UIEdgeInsetsMake(206, 0, 0, 0)
//        self.publishedTableView?.tableView.tableHeaderView = self.pubHeader!
        
        self.topicsTableView = ZXTopicsTableViewController(style: UITableViewStyle.Plain, type: TopicType.topicTypePerson)
        self.topicsTableView?.delegate = self
        self.scroll?.addSubview((self.topicsTableView?.view)!)
        self.topicsTableView?.view.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width * 2), 0, (self.scroll?.bounds.width)!, (self.scroll?.bounds.height)!)
        self.topicsTableView?.tableView.contentInset = UIEdgeInsetsMake(206, 0, 0, 0)
//        self.topicsTableView?.tableView.tableHeaderView = self.topHeader!
        
        self.stableSlider = UIView(frame: CGRectMake(0, 236, UIScreen.mainScreen().bounds.size.width, 35))
        self.stableSlider.backgroundColor = Colors.UIColorFromRGB(0xeceff1)
        self.view.addSubview(self.stableSlider)
        
        self.zanButton = UIButton(frame: CGRectMake(0, 0, self.stableSlider.frame.size.width / 3, self.stableSlider.frame.size.height))
        self.zanButton?.setTitle("点赞", forState: UIControlState.Normal)
        self.zanButton?.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.stableSlider.addSubview(self.zanButton!)
        
        self.pubButton = UIButton(frame: CGRectMake(self.stableSlider.frame.size.width / 3, 0, self.stableSlider.frame.size.width / 3, self.stableSlider.frame.size.height))
        self.pubButton?.setTitle("发布", forState: UIControlState.Normal)
        self.pubButton?.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.stableSlider.addSubview(self.pubButton!)
        
        self.topButton = UIButton(frame: CGRectMake((self.stableSlider.frame.size.width * 2) / 3, 0, self.stableSlider.frame.size.width / 3, self.stableSlider.frame.size.height))
        self.topButton?.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.topButton?.setTitle("收藏", forState: UIControlState.Normal)
        self.stableSlider.addSubview(self.topButton!)
        
        self.displayingTable = self.zansTableView
        
        self.view.insertSubview(self.navi!, aboveSubview: self.staleHeader)
        
        self.indicator = UIView(frame: CGRectMake(0, 33, self.stableSlider.frame.size.width / 3, 2))
        self.indicator.backgroundColor = Colors.navigationColor()
        self.stableSlider.addSubview(self.indicator)
        
        if self.user != nil {
            self.staleHeader.user = self.user
        } else {
            self.staleHeader.user = LoginedUser.sharedInstance
        }
        
        if self.user != nil {
            let uno = String(self.user?.userID)
            
            let para = [
                "uno": uno,
                ]
            
            Alamofire.request(.POST, "http://www.npinfang.com/scan/user/page", parameters: para).responseJSON(completionHandler: { (response) in
                print("the response is \(response)")
            })
            
            return;
        }
        
        Alamofire.request(.POST, "http://www.npinfang.com/scan/user/page", parameters: ["uno" : "1"]).responseJSON(completionHandler: { (response) in
            print("the response is \(response)")
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                print("the Json is \(JSON)")
                print("so the data is \(JSON["data"])")
                
                let datas = JSON["data"]!
                
                var zans = datas!["likes"]!!.integerValue
                
                let zan = "点赞" + String(zans)
                let pub = "发布" + String(datas!["gives"]!!.integerValue)
                let fav = "收藏" + String(datas!["gains"]!!.integerValue)
                
                self.zanButton?.setTitle(zan, forState: UIControlState.Normal)
                self.pubButton?.setTitle(pub, forState: UIControlState.Normal)
                self.topButton?.setTitle(fav, forState: UIControlState.Normal)
                
                let icon = datas!["icon"]!!
                self.staleHeader.avatar?.kf_setImageWithURL(NSURL.fileURLWithPath(icon as! String), placeholderImage: UIImage(named: "nIcon"))
                
            } catch {
                
            }
        })
    }
    
    @IBAction func backButtonPressed(sender : AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var rect = self.indicator.frame
        rect.origin.x = scrollView.contentOffset.x / 3
        if rect.origin.x < 0 {
            rect.origin.x = 0
        } else if rect.origin.x > self.stableSlider.frame.size.width * 2 / 3 {
            rect.origin.x = self.stableSlider.frame.size.width * 2 / 3
        }
        
        self.indicator.frame = rect
        
        if scrollView == self.scroll {
            
            let index = (self.scroll?.contentOffset.x)! / (self.scroll?.bounds.size.width)!
            
            if index == 0 {
                self.displayingTable = self.zansTableView
                
            } else if index == 1 {
                self.displayingTable = self.publishedTableView
                
            } else if index == 2 {
                
                self.displayingTable = self.topicsTableView
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        if scrollView == self.scroll {
            let index = (self.scroll?.contentOffset.x)! / (self.scroll?.bounds.size.width)!

            if index == 1 {
//                nowFrame = (self.zansTableView?.tableView.convertRect(self.zanHeader.bounds, toView: self.view))!
//                self.staleHeader.frame = nowFrame
//                self.view.addSubview(self.staleHeader)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if scrollView == self.scroll {
            
//            self.staleHeader.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zanButtonPressed(sender : UIButton) {
        
    }
    
    func productsTableViewControllerDidScroll(sender: ZXProductsTableViewController) {
        
        if sender == self.displayingTable {
            print("the offset y is \(self.displayingTable?.tableView.contentOffset.y)")
            
            if self.displayingTable?.tableView.contentOffset.y > 0 {
                self.staleHeader.frame = CGRectMake(0, 64-((self.displayingTable?.tableView.contentOffset.y)! + 206), UIScreen.mainScreen().bounds.size.width, 172)
            }
            
            self.topicsTableView?.tableView.contentOffset = (self.displayingTable?.tableView.contentOffset)!
            if self.displayingTable == self.zansTableView {
                self.publishedTableView?.tableView.contentOffset = (self.zansTableView?.tableView.contentOffset)!
            } else if self.displayingTable == self.publishedTableView {
                self.zansTableView?.tableView.contentOffset = (self.publishedTableView?.tableView.contentOffset)!
            }
            
            var off = 236-((self.displayingTable?.tableView.contentOffset.y)! + 206)
            if off < 64.0 {
                off = 64.0
            }
            
            if self.displayingTable?.tableView.contentOffset.y > 0 {
                self.stableSlider.frame = CGRectMake(0, off, UIScreen.mainScreen().bounds.size.width, 35)
            }
        }
    }
    
    func productsTableViewControllerDidSelectProduct(product: ZXNews?) {
        let controller = ZXProductDetailViewController(nibName: "ZXProductDetailViewController", bundle: nil)
        controller.news = product
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func topicsTableViewControllerDidScroll(sender: ZXTopicsTableViewController) {
        
        if sender == self.displayingTable {
            
            if self.displayingTable?.tableView.contentOffset.y > 0 {
                 self.staleHeader.frame = CGRectMake(0, 64-((self.displayingTable?.tableView.contentOffset.y)! + 206), UIScreen.mainScreen().bounds.size.width, 172)
            }
           
            self.zansTableView?.tableView.contentOffset = (self.displayingTable?.tableView.contentOffset)!
            self.publishedTableView?.tableView.contentOffset = (self.displayingTable?.tableView.contentOffset)!
            
            var off = 236-((self.displayingTable?.tableView.contentOffset.y)! + 206)
            if off < 64.0 {
                off = 64.0
            }
            
            if self.displayingTable?.tableView.contentOffset.y > 0 {
                self.stableSlider.frame = CGRectMake(0, off, UIScreen.mainScreen().bounds.size.width, 35)
            }
        }
    }
    
    func topicsTableViewControllerDidSelectTopic(topic: ZXTopic?) {
        let viewController = ZXTopicDetailViewController(nibName: "ZXTopicDetailViewController", bundle: nil)
        viewController.topic = topic
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
