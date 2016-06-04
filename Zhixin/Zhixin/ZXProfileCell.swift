//
//  ZXProfileCell.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXProfileCell: UITableViewCell {
    
    @IBOutlet var icon : UIImageView?
    @IBOutlet var black : UILabel?
    @IBOutlet var gray : UILabel?
    var va : NSDictionary?
    var dict : NSDictionary? {
        set (newV) {
            
            let imna = newV?["im"] as? String
            if imna != nil {
                self.icon?.image = UIImage(named: imna!)
            } else {
                self.icon?.image = nil
            }
            
            self.black?.text = newV?["title"] as? String
            self.gray?.text = newV?["sub"] as? String
            
            if ((self.black?.text) != nil) {
                self.contentView.backgroundColor = UIColor.whiteColor()
            } else {
                self.contentView.backgroundColor = Colors.UIColorFromRGB(0xf2f2f2)
            }
            
            print ( "the is ", newV?["title"])
        }
        
        get {
            
            return ["title" : (black?.text!)!]
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
