//
//  ZXProductCommentCell.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/13.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

class ZXProductCommentCell: UITableViewCell {
    
    var comment : ZXProductComment? {
        
        set (newV) {
            if newV?.avatar != nil {
                self.avatar?.kf_setImageWithURL(NSURL(string: (newV?.avatar)!)!, placeholderImage: UIImage(named: "nIcon"))
            }
            self.name?.text = newV?.nickName
//            self.time?.text = String(newV?.time)
            self.des?.text = newV?.content
            
            var rect = self.des?.frame
            rect?.size.width = UIScreen.mainScreen().bounds.size.width - 66
            rect?.size.height = (newV?.content?.heightWithConstrainedWidth(UIScreen.mainScreen().bounds.size.width - 66, font: UIFont.systemFontOfSize(13.0)))!
            self.des?.frame = rect!
            self.time?.text = newV?.date
            
        }
        
        get {
            return self.comment
        }
    }
    
    @IBOutlet var avatar : UIImageView?
    @IBOutlet var name : UILabel?
    @IBOutlet var time : UILabel?
    @IBOutlet var des : UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatar?.layer.cornerRadius = (self.avatar?.frame.size.height)! / 2.0
        self.avatar?.clipsToBounds = true
//        [self.des setPreferredMaxLayoutWidth:200.0];
//        self.des?.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 66
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
