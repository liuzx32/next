//
//  ImageUtility.h
//  YouDaoCube
//
//  Created by He Yidong on 7/20/11.
//  Copyright 2011 Youdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface ImageUtility: NSObject {

}

+ (UIImage *) getSizedImage: (UIImage*) origImage toSize: (CGSize) size;
+ (CGSize)fitSize: (CGSize) originSize toFit: (CGSize) aSize;

+ (unsigned char *) bitmapFromImage: (UIImage *) image;

+ (UIImage *)imageWithBits: (unsigned char *) bits withSize: (CGSize) size;


+ (UIImage*) imageHorizonalFliped: (UIImage*) image;

// 从DoctorClient的补充
+ (CGContextRef)newRGBBitmapContent: (CGSize) size;
+ (UIImage*)imageRotated:(UIImage*)image angle:(CGFloat)angle;




+ (UIImage*) getNetworkImage: (NSString*) url;

//
// 限制大小为32K
//
+ (UIImage*) ensureWeixinThumbnailSafe: (UIImage*) image;


//
// 限制大小为10M，一般情况下都不会超过这个限制
//
+ (UIImage*) ensureWeixinImageSafe: (UIImage*) image;

//
// 限制头像最大100K
//
+ (UIImage*) ensurePortraitSafe:(UIImage*)image;

//
// 限制大小单位是K
//
+ (UIImage*) ensureImageSafe: (UIImage*) image dataSize:(NSInteger)dataSize;

@end
