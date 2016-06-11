//
//  ZXDateProductsViewController.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/6/4.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXDateProductsViewController: UIViewController, productsTableViewControllerDelegate {
    
    var date : String?
    var tt : String?
    var tableview : ZXProductsTableViewController?
    @IBOutlet var naviView : UIView?
    @IBOutlet var tLabel : UILabel?
    @IBOutlet var shareButton : ZXNavigationButton?
    @IBOutlet var addButton : ZXNavigationButton?
    var shareView : ZXShareView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        self.naviView?.backgroundColor = Colors.navigationColor()
        self.tLabel?.text = self.tt!
        
        self.tableview = ZXProductsTableViewController(style: UITableViewStyle.Plain)
        self.tableview!.productType = productsType.atDate
        self.view?.addSubview(self.tableview!.view)
        self.tableview!.view.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view?.frame.size.height)! - 20)
        self.tableview?.delegate = self
        self.tableview?.startSearching(self.date!, date: self.date)
        
        self.shareView = ZXShareView( frame: UIScreen.mainScreen().bounds)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func productsTableViewControllerDidScroll(sender : ZXProductsTableViewController) {
        
    }
    func productsTableViewControllerDidSelectProduct(product: ZXNews?) {
        let controller = ZXProductDetailViewController(nibName: "ZXProductDetailViewController", bundle: nil)
        controller.news = product
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func backButtonPressed(sender : AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shareButtonPressed(sender : AnyObject) {
        self.view.addSubview(self.shareView!)
        self.shareView?.show()
    }
    
    @IBAction func addButttonPressed(sender : AnyObject) {
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
}
