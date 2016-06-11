//
//  SecondViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/9.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIScrollViewDelegate {
    
    var navigationView : UIView!
    var icon : UIImageView!
    var searchButton : ZXNavigationButton!
    var addButton : ZXNavigationButton!
    @IBOutlet var backView : UIView!
    var indicator : UIView!
    
    var newestButton : UIButton!
    var hotestButton : UIButton!
    @IBOutlet var scrollView : UIScrollView!
    var newestViewController : ZXTopicsTableViewController!
    var hotestViewController : ZXTopicsTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationView = UIView(frame: CGRectMake(0, 0, self.view!.frame.size.width, 64))
        self.navigationView.backgroundColor = Colors.UIColorFromRGB(0x0097e0)
        self.navigationView.clipsToBounds = true
        
        self.icon = UIImageView(frame: CGRectMake(15, 25, 30, 30))
        self.icon.backgroundColor = UIColor.clearColor()
        self.icon.contentMode = UIViewContentMode.ScaleAspectFit
        self.icon.image = UIImage(named: "nIcon")
        self.navigationView.addSubview(self.icon)
        
        self.searchButton = ZXNavigationButton(frame: CGRectMake(self.view.frame.size.width - 100, 20, 40, 40))
        self.searchButton.addTarget(self, action: #selector(SecondViewController.searchButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationView.addSubview(self.searchButton)
        self.searchButton.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        
        self.addButton = ZXNavigationButton(frame: CGRectMake(self.view.frame.size.width - 50, 20, 40, 40))
        self.addButton.addTarget(self, action: #selector(SecondViewController.addButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addButton.setImage(UIImage(named: "add"), forState: UIControlState.Normal)
        self.navigationView.addSubview(self.addButton)
        
        self.newestButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 33))
        self.newestButton.setTitle("最新", forState: UIControlState.Normal)
        self.newestButton.setTitleColor(Colors.navigationColor(), forState: UIControlState.Selected)
        self.newestButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.newestButton.addTarget(self, action: #selector(SecondViewController.newestButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.backView.addSubview(self.newestButton)
        self.newestButton.selected = true
        self.newestButton.titleLabel?.font = UIFont.systemFontOfSize(18)
        
        self.hotestButton = UIButton(frame: CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 33))
        self.hotestButton.setTitle("最热", forState: UIControlState.Normal)
        self.hotestButton.setTitleColor(Colors.navigationColor(), forState: UIControlState.Selected)
        self.hotestButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.hotestButton.addTarget(self, action: #selector(SecondViewController.hotestButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.hotestButton.titleLabel?.font = UIFont.systemFontOfSize(18)
        self.backView.addSubview(self.hotestButton)
        
        self.indicator = UIView(frame: CGRectMake(0, 33, self.view.frame.size.width / 2, 2))
        self.indicator.backgroundColor = Colors.navigationColor()
        self.backView.addSubview(self.indicator)
        self.backView.backgroundColor = Colors.UIColorFromRGB(0xeceff1)
        
        self.view.addSubview(self.navigationView)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.scrollView.frame.size.height);
        self.scrollView.pagingEnabled = true
        
        self.newestViewController = ZXTopicsTableViewController(style: UITableViewStyle.Plain, type: TopicType.topicTypeNewest)
        self.newestViewController.view.frame = self.scrollView.bounds
        self.addChildViewController(self.newestViewController)
        self.scrollView.addSubview(self.newestViewController.view)
        
        print("the scrollview width is", self.scrollView.contentSize.width / 2)
        
        self.hotestViewController = ZXTopicsTableViewController(style: UITableViewStyle.Plain, type: TopicType.topicTypeHotest)
        self.hotestViewController.view.frame = CGRectMake(self.scrollView.contentSize.width / 2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)
        self.addChildViewController(self.hotestViewController)
        self.scrollView.addSubview(self.hotestViewController.view)
        
        self.scrollView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    func searchButtonPressed(sender : UIButton) {
        print("search!")
        
        let controller = ZXSearchViewController(nibName: "ZXSearchViewController", bundle: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func addButtonPressed(sender : UIButton) {
        
        if LoginedUser.sharedInstance.userID <= 0 {
            let loginViewcontroller = ZXLoginViewController(nibName: "ZXLoginViewController", bundle: nil)
            let navi = UINavigationController(rootViewController: loginViewcontroller)
            navi.navigationBar.hidden = true
            self.presentViewController(navi, animated: true, completion: {
                
            })
        } else {
            
            let controller = ZXPublishNewProductViewController(type: NewType.newTypeTopic)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func newestButtonPressed(sender : UIButton) {
        self.newestButton.selected = true
        self.hotestButton.selected = false
        
        UIView.animateWithDuration(0.2) { 
            self.indicator.frame = CGRectMake(0, 33, self.view.frame.size.width / 2, 2)
            
            self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func hotestButtonPressed(sender : UIButton) {
        
        self.newestButton.selected = false
        self.hotestButton.selected = true
        
        UIView.animateWithDuration(0.2) {
            self.indicator.frame = CGRectMake(self.view.frame.size.width / 2, 33, self.view.frame.size.width / 2, 2)
            
            self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentSize.width / 2, 0), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width
        
        if index == 0 {
            self.indicator.frame = CGRectMake(0, 33, self.view.frame.size.width / 2, 2)
        } else {
            self.indicator.frame = CGRectMake(self.view.frame.size.width / 2, 33, self.view.frame.size.width / 2, 2)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var rect = self.indicator.frame
        rect.origin.x = scrollView.contentOffset.x / 2
        self.indicator.frame = rect
    }
}

