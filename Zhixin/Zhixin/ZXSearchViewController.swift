//
//  ZXSearchViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/16.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXSearchViewController: UIViewController, UIScrollViewDelegate, topicsTableViewControllerDelegate, ZXDatePicerDelegate, productsTableViewControllerDelegate {
    
    @IBOutlet var backView: UIView?
    @IBOutlet var scroll : UIScrollView?
    var productButton : UIButton!
    var topicButton : UIButton!
    var indicator : UIView!
    @IBOutlet var field : UITextField?
    
    var datePicker : ZXDatePicker?
    var black : UIView?
    
    var productsView : ZXProductsTableViewController!
    var topicsView : ZXTopicsTableViewController!
    
    var searchDate : String?
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true

        self.productButton = UIButton(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width / 2, 35))
        self.productButton.setTitle("产品", forState: UIControlState.Normal)
        self.productButton.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.productButton.setTitleColor(Colors.navigationColor(), forState: UIControlState.Selected)
        self.backView?.addSubview(self.productButton)
        self.productButton.addTarget(self, action: #selector(ZXSearchViewController.productButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.productButton.selected = true
        
        self.topicButton = UIButton(frame: CGRectMake(self.productButton.frame.size.width, 0, self.productButton.frame.size.width, 35))
        self.topicButton.setTitle("主题", forState: UIControlState.Normal)
        self.topicButton.setTitleColor(Colors.UIColorFromRGB(0x333333), forState: UIControlState.Normal)
        self.topicButton.setTitleColor(Colors.navigationColor(), forState: UIControlState.Selected)
        self.backView?.addSubview(self.topicButton)
        self.topicButton.addTarget(self, action: #selector(ZXSearchViewController.topicButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.indicator = UIView(frame: CGRectMake(0, 33, UIScreen.mainScreen().bounds.size.width / 2, 2))
        self.backView?.addSubview(self.indicator)
        self.indicator.backgroundColor = Colors.navigationColor()
        self.backView?.backgroundColor = Colors.UIColorFromRGB(0xeceff1)
        
        self.scroll?.pagingEnabled = true
        self.scroll?.contentSize = CGSizeMake((UIScreen.mainScreen().bounds.size.width) * 2, (self.scroll?.frame.size.height)!)
        self.scroll?.delegate = self
        
        self.productsView = ZXProductsTableViewController(style: UITableViewStyle.Plain)
        self.productsView.productType = productsType.search
        self.scroll?.addSubview(self.productsView!.view)
        self.productsView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.scroll?.frame.size.height)!)//UIScreen.mainScreen().bounds.size.width
        self.productsView.delegate = self;
        
        self.topicsView = ZXTopicsTableViewController(style: UITableViewStyle.Plain, type: TopicType.topicTypeSearch)
        self.scroll?.addSubview(self.topicsView.view)
        self.topicsView.view.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width, 0, self.view.frame.size.width, (self.scroll?.bounds.size.height)!)
        
        self.field?.becomeFirstResponder()
        
        self.black = UIView(frame: UIScreen.mainScreen().bounds)
        self.black?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        var rect = CGRectZero
        rect.size.width = UIScreen.mainScreen().bounds.size.width
        rect.origin.y = UIScreen.mainScreen().bounds.size.height
        rect.size.height = 330
        self.datePicker = NSBundle.mainBundle().loadNibNamed("ZXDatePicker", owner: nil, options: nil)[0] as? ZXDatePicker
        self.datePicker?.delegate = self
        self.black!.addSubview(self.datePicker!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.view.bringSubviewToFront(self.datePicker!)
    }
    
    func productButtonPressed(sender : AnyObject) {
        
        self.scroll?.contentOffset = CGPointMake(0, 0)
        self.productButton.selected = true
        self.topicButton.selected = false
        
        UIView.animateWithDuration(0.2) {
            self.indicator.frame = CGRectMake(0, 33, (self.backView?.frame.size.width)! / 2, 2)
        }
    }
    
    func topicButtonPressed(sender : AnyObject) {
        
        self.scroll?.contentOffset = CGPointMake((self.scroll?.frame.size.width)!, 0)
        self.productButton.selected = false
        self.topicButton.selected = true
        
        UIView.animateWithDuration(0.2) {
            self.indicator.frame = CGRectMake((self.backView?.frame.size.width)! / 2, 33, (self.backView?.frame.size.width)! / 2, 2)
        }
    }

    @IBAction func backButtonPressed(sender : AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func searchButtonPressed(sender : AnyObject) {
        
        self.topicsView.startSearchWith((self.field?.text)!)
        self.productsView.startSearching((self.field?.text)!, date: self.searchDate)
        
        self.field?.resignFirstResponder()
    }
    
    @IBAction func clanderButtonPressed(sender : AnyObject) {
        
        self.field?.resignFirstResponder()
        self.view.addSubview(self.black!)
        
        var rect = self.datePicker?.frame
        rect?.size.width = UIScreen.mainScreen().bounds.size.width
        rect?.origin.y = UIScreen.mainScreen().bounds.size.height - (self.datePicker?.frame.size.height)!
        self.datePicker?.frame = rect!
        
//        UIView.animateWithDuration(0.3) { 
//            self.datePicker?.frame = rect!
//        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var rect = self.indicator.frame
        rect.origin.x = (scroll?.contentOffset.x)! / 2
        self.indicator.frame = rect
    }
    
    func topicsTableViewControllerDidScroll(sender : ZXTopicsTableViewController) {
        
        self.field?.resignFirstResponder()
    }
    
    func topicsTableViewControllerDidSelectTopic(topic: ZXTopic?) {
        let viewController = ZXTopicDetailViewController(nibName: "ZXTopicDetailViewController", bundle: nil)
        viewController.topic = topic
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func productsTableViewControllerDidSelectProduct(product: ZXNews?) {
        
        let controller = ZXProductDetailViewController(nibName: "ZXProductDetailViewController", bundle: nil)
        controller.news = product
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func productsTableViewControllerDidScroll(sender: ZXProductsTableViewController) {
        self.field?.resignFirstResponder()
    }
    
    func pickerDidCancel() {
        
        self.black?.removeFromSuperview()
        
        var rect = self.datePicker?.frame
        rect?.origin.y = UIScreen.mainScreen().bounds.size.height
        
        UIView.animateWithDuration(0.3) {
            self.datePicker?.frame = rect!
        }
    }
    
    func pickerDidSelect(date: String) {
        
        self.searchDate = date
        
        self.black?.removeFromSuperview()
        
        var rect = self.datePicker?.frame
        rect?.origin.y = UIScreen.mainScreen().bounds.size.height
        self.datePicker?.frame = rect!
        
        var searching = self.field?.text
        
        if (searching) != nil {
            self.field?.text = date + searching!
        } else {
            self.field?.text = date
        }
    }
}
