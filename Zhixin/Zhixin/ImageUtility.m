//
//  ImageUtility.m
//  YouDaoCube
//
//  Created by He Yidong on 7/20/11.
//  Copyright 2011 Youdao. All rights reserved.
//

#import "ImageUtility.h"


@implementation ImageUtility

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGSize) fitSize: (CGSize) originSize toFit: (CGSize) aSize {
    CGFloat scale;
    CGSize newSize = originSize;
    if (newSize.height && newSize.height > aSize.height) {
        scale = aSize.height / newSize.height;
        newSize.width *= scale;
        newSize.height *= scale;
    }

    if (newSize.width && newSize.width > aSize.width) {
        scale = aSize.width / newSize.width;
        newSize.width *= scale;
        newSize.height *= scale;
    }
    return newSize;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage *) getSizedImage: (UIImage*) origImage toSize: (CGSize) size {
    CGSize origSize = origImage.size;
    CGSize newSize = [ImageUtility fitSize: origSize toFit: size];

    UIGraphicsBeginImageContext(newSize);

    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    [origImage drawInRect: rect];

    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // newSize = newImg.size;

    return newImg;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (unsigned char *) bitmapFromImage: (UIImage *) image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == nil) {
        return NULL;
    }

    void *bitmapData = malloc(image.size.width * image.size.height * 4);
    if (bitmapData == nil) {
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }

    CGContextRef context = CGBitmapContextCreate(bitmapData, image.size.width, image.size.height, 8,
                                                 image.size.width * 4,
                                                 colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);

    CGColorSpaceRelease(colorSpace);
    if (context == nil) {
        free(bitmapData);
        return nil;

    }

    CGRect rect =  CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    unsigned char *data = CGBitmapContextGetData(context);

    CGContextRelease(context);

    return data;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage *) imageWithBits: (unsigned char *) bits withSize: (CGSize) size {
	// Create a color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL) {
        return nil;
    }

    CGContextRef context = CGBitmapContextCreate (bits, size.width, size.height, 8, size.width * 4,
                                                  colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
		CGColorSpaceRelease(colorSpace );
		return nil;
    }

    CGColorSpaceRelease(colorSpace);
	CGImageRef ref = CGBitmapContextCreateImage(context);
	//free(CGBitmapContextGetData(context));
	CGContextRelease(context);

	UIImage *img = [UIImage imageWithCGImage:ref];
	CFRelease(ref);
	return img;
}

+ (UIImage*) imageHorizonalFliped: (UIImage*) image {
    return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUpMirrored];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGContextRef) newRGBBitmapContent: (CGSize) size { //  返回值必须主动释放
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == nil) {
        return nil;
    }
    
    void *bitmapData = malloc(size.width * size.height * 4);
    if (bitmapData == nil) {
        CGColorSpaceRelease(colorSpace);
        return nil;
    }
    
    CGContextRef context = CGBitmapContextCreate(bitmapData, size.width, size.height, 8, size.width * 4,
                                                 colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
    
    CGColorSpaceRelease(colorSpace);
    free(bitmapData);
    if (context == nil) {
        return nil;
        
    } else {
        return context;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIImage*)imageRotated:(UIImage*)image angle:(CGFloat)angle {
    
    CGImageRef imgRef = image.CGImage;
    CGFloat angleInRadians = angle * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, YES);
    CGContextSetShouldAntialias(bmContext, YES);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext, +(rotatedRect.size.width/2), +(rotatedRect.size.height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext, -(rotatedRect.size.width/2), -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0, rotatedRect.size.width, rotatedRect.size.height), imgRef);
    
    
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);

    UIImage* resultImage = [UIImage imageWithCGImage: rotatedImage];
    CFRelease(rotatedImage);
    
    return resultImage;
}

//
// 限制大小为10M，一般情况下都不会超过这个限制
//
+ (UIImage*) ensureWeixinImageSafe: (UIImage*) image {
    // 2621440 = 10 * 1024 * 1024 / 4(4个颜色通道)
    if (image.size.width * image.size.height > 2621440) {
        float scale = sqrt(2621440.0 / (image.size.width * image.size.height));
        CGSize size = CGSizeMake((int)(image.size.width * scale), (int)(image.size.height * scale));
        image = [ImageUtility getSizedImage: image toSize: size];
    }
    return image;
}

+ (UIImage*) ensureImageSafe: (UIImage*) image dataSize:(NSInteger)dataSize {
    // 2621440 = dataSize * 1024 / 4(4个颜色通道)
    NSInteger targetSize = dataSize * 1024 / 4;
    if (image.size.width * image.size.height > targetSize) {
        float scale = sqrt((CGFloat)targetSize / (image.size.width * image.size.height));
        CGSize size = CGSizeMake((int)(image.size.width * scale), (int)(image.size.height * scale));
        image = [ImageUtility getSizedImage: image toSize: size];
    }
    return image;
}

+ (UIImage*) ensurePortraitSafe:(UIImage*)image {
    return [self ensureImageSafe: image dataSize: 500];
}

+ (UIImage*) getNetworkImage: (NSString*) url {
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage* image = [UIImage imageWithData:data];
    return image;
}

//
// 限制大小为32K
//
+ (UIImage*) ensureWeixinThumbnailSafe: (UIImage*) image {
    // 8192.0 = 32 * 1024 / 4(4个颜色通道)
    if (image.size.width * image.size.height > 8192.0) {
        float scale = sqrt(8192.0 / (image.size.width * image.size.height));
        CGSize size = CGSizeMake((int)(image.size.width * scale), (int)(image.size.height * scale));
        image = [ImageUtility getSizedImage: image toSize: size];
    }
    return image;
}

@end
