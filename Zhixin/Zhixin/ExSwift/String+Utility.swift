//
//  String+Utility.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/5/28.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return CGFloat(ceilf(Float(boundingBox.height)))
    }
}