//
//  ZXDatePicker.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/16.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

protocol ZXDatePicerDelegate {
    
    func pickerDidCancel()
    func pickerDidSelect(date : String)
}

class ZXDatePicker: UIView {
    
    var delegate : ZXDatePicerDelegate?

    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var cancelButton : UIButton!
    @IBOutlet var confirmButton : UIButton!
    @IBOutlet var dateLabel : UILabel!
    
//    init(frame: CGRect, dele : ZXDatePicerDelegate) {
//        
////        self.delegate = dele
//        super.init(frame: frame)
//    
//
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.datePicker?.addTarget(self, action: #selector(ZXDatePicker.pickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        var nowString = dateFormatter2.stringFromDate(NSDate())
        self.dateLabel.text = nowString
    }
    
    @IBAction func cancelButtonPressed(sender : AnyObject) {
        
        self.delegate?.pickerDidCancel()
    }

    @IBAction func confirmButtonPressed(sender : AnyObject) {
        
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyyMMdd"
        var nowString = dateFormatter2.stringFromDate(self.datePicker.date)
        
        self.delegate?.pickerDidSelect(nowString)
    }
    
    func pickerChanged(sender : UIDatePicker) {
        
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        var nowString = dateFormatter2.stringFromDate(sender.date)
        
        var wee = self.dayOfWeek(sender.date)
        
        let ff = nowString + wee
        
        self.dateLabel?.text = ff
    }
    
    func dayOfWeek(date : NSDate) -> String {
        
        let now = NSDate()
        
        let interval = now.timeIntervalSince1970;
        
        
        let days = Int(interval / 86400);
        
        
        let num = (days - 3) % 7;
        
        switch num {
        case 1:
            return "星期一"
            break
        case 2:
            return "星期二"
            break
        case 3:
            return "星期三"
            break
        case 4:
            return "星期四"
            break
        case 5:
            return "星期五"
            break
        case 6:
            return "星期六"
            break
        case 7 :
            return "星期日"
            break
        default:
            return ""
        }
        
        return ""
    }
}
