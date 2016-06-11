//
//  ZXNewsTableViewCell.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/9.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit
import Alamofire

class ZXNewsTableViewCell: UITableViewCell {
    @IBOutlet var zanButton : UIButton!
    @IBOutlet var zanIcon : UIImageView!
    @IBOutlet var zanLabel : UILabel!
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var conLabel : UILabel!
    
    @IBOutlet var avatar : UIImageView!
    @IBOutlet var avatarButton : UIButton!

    override func awakeFromNib() {
        self.selectionStyle = UITableViewCellSelectionStyle.Blue
        self.zanButton.layer.cornerRadius = 4;
        self.zanButton.layer.borderWidth = 0.5;
        self.zanButton.layer.borderColor = Colors.UIColorFromRGB(0x757575).CGColor
        self.zanLabel.textColor = Colors.UIColorFromRGB(0x757575)
        self.nameLabel.textColor = Colors.UIColorFromRGB(0x0097e0)
        self.conLabel.textColor = Colors.UIColorFromRGB(0x757575)
        self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2
        self.avatar.clipsToBounds = true
        self.avatarButton.userInteractionEnabled = true
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.contentView.backgroundColor = UIColor(red:217.0 / 255.0, green: 240.0 / 255.0 , blue: 250.0 / 255.0 , alpha: 1)
        } else {
            self.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.contentView.backgroundColor = UIColor(red:217.0 / 255.0, green: 240.0 / 255.0 , blue: 250.0 / 255.0 , alpha: 1)
        } else {
            self.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    @IBAction func avatarButtonPressed(sender : AnyObject) {
        
        let vc = ZXPersonViewController(nibName: "ZXPersonViewController", bundle: nil)
        vc.user = self.news?.author
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func zanButtonPressed(sender : AnyObject) {
        
        if self.news?.zaned == true {
            
            let paras = ["pno" : String((self.news?.pNo)!)]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/lose/item", parameters: paras).responseJSON(completionHandler: { (response) in
                
                self.zanButton?.userInteractionEnabled = true
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        let data = JSON["data"] as? NSDictionary
                        
                        let score = data?.valueForKey("score") as! NSInteger
                        
                        self.zanLabel?.text = String(score)
                        self.zanButton.layer.borderColor = Colors.UIColorFromRGB(0x757575).CGColor
                        self.zanLabel.textColor = Colors.UIColorFromRGB(0x757575)
                        self.shadowN?.zaned = false
                        self.news?.zans = (self.news?.zans)! - 1
                        if self.news?.zans <= 0 {
                            self.news?.zans = 0
                        }
                        
                    } else {
                        
                    }
                    
                } catch {
                    
                }
            })
            
        } else {
            
            let paras = ["pno" : String((self.news?.pNo)!)]
            
            Alamofire.request(.POST, "http://www.npinfang.com/apps/vote/item", parameters: paras).responseJSON(completionHandler: { (response) in
                
                self.zanButton?.userInteractionEnabled = true
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                    //                print("the Json is \(JSON)")
                    print("so the data is \(JSON["data"]!)")
                    
                    let code = JSON["code"]!!.integerValue
                    if code == 200 {
                        let data = JSON["data"] as? NSDictionary
                        
                        let score = data?.valueForKey("score") as! NSInteger
                        
                        self.zanLabel?.text = String(score)
                        self.zanButton.layer.borderColor = Colors.UIColorFromRGB(0x0097e0).CGColor
                        self.zanLabel.textColor = Colors.UIColorFromRGB(0x0097e0)
                        self.shadowN?.zaned = true
                        self.news?.zans = (self.news?.zans)! + 1
                        
                    } else {
                        
                    }
                    
                } catch {
                    
                }
            })
        }
    }
    
    var shadowN : ZXNews?
    
    var news : ZXNews? {
        
        set (newV) {
            
            self.shadowN = newV
            
            self.nameLabel.text = newV?.title
            self.conLabel.text = newV?.content
            
            self.zanLabel.text = String((newV?.zans)!)
            
            let zanleme : Bool = (newV?.zaned)!
            
            if zanleme == false {
                self.zanButton.layer.borderColor = Colors.UIColorFromRGB(0x757575).CGColor
                self.zanLabel.textColor = Colors.UIColorFromRGB(0x757575)
            } else {
                self.zanButton.layer.borderColor = Colors.UIColorFromRGB(0x0097e0).CGColor
                self.zanLabel.textColor = Colors.UIColorFromRGB(0x0097e0)
            }
            
            self.avatar.kf_setImageWithURL(NSURL(string: (newV?.author?.avatar!)!)!)
        }
        
        get {
            return self.shadowN
        }
    }
}
