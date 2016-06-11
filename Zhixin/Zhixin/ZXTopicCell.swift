//
//  ZXTopicCell.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/10.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXTopicCell: UITableViewCell {
    
    @IBOutlet var conImageView : UIImageView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var desLabel : UILabel!
    
    var topic : ZXTopic? {
        set(newValue) {
            
            self.conImageView.kf_setImageWithURL(NSURL(string: (newValue?.imageURL)!)!)
            self.nameLabel.text = newValue?.name
            let des = String((newValue?.products)!) + "个产品 " + String((newValue?.favos)!) + "人收藏"
            self.desLabel.text = des
        }
        
        get {
            return ZXTopic(dict: NSMutableDictionary())
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
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
    
}
