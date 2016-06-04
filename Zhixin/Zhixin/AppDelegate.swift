//
//  AppDelegate.swift
//  Zhixin
//
//  Created by zhangyuanqing on 16/4/9.
//  Copyright © 2016年 Zhixin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        ShareSDK.registerApp("134609b6fa744", activePlatforms: ["1", "22"], onImport: { (platform) in
//            switch (platform)
//            {
//            case SSDKPlatformType.TypeWechat:
////                [ShareSDKConnector connectWeChat:[WXApi class]];
//                ShareSDKConnector.connectWeChat(WXApi.self)
//                break;
//            case SSDKPlatformType.TypeSinaWeibo:
////                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                ShareSDKConnector.connectWeibo(WeiboSDK.self)
//                break;
//            default:
//                break;
//            }
//            }) { (platformType, appInfo) in
////                switch (platformType)
////                {
////                case SSDKPlatformTypeSinaWeibo:
////                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
////                    [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
////                    appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
////                    redirectUri:@"http://www.sharesdk.cn"
////                    authType:SSDKAuthTypeBoth];
////                    break;
////                case SSDKPlatformTypeWechat:
////                    [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
////                    appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
////                    break;
////                case SSDKPlatformTypeQQ:
////                    [appInfo SSDKSetupQQByAppId:@"100371282"
////                    appKey:@"aed9b0303e3ed1e27bae87c33761161d"
////                    authType:SSDKAuthTypeBoth];
////                    break;
////                case SSDKPlatformTypeRenren:
////                    [appInfo        SSDKSetupRenRenByAppId:@"226427"
////                    appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
////                    secretKey:@"f29df781abdd4f49beca5a2194676ca4"
////                    authType:SSDKAuthTypeBoth];
////                    break;
////                case SSDKPlatformTypeGooglePlus:
////                    [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
////                    clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
////                    redirectUri:@"http://localhost"
////                    authType:SSDKAuthTypeBoth];
////                    break;
////                default:
////                    break;
////                }
//                
//                return true
//        }
        
        if NSUserDefaults.standardUserDefaults().integerForKey("userID") > 0 {
            LoginedUser.sharedInstance.userID = Int32(NSUserDefaults.standardUserDefaults().integerForKey("userID"))
            LoginedUser.sharedInstance.nickName = NSUserDefaults.standardUserDefaults().objectForKey("nickname") as? String
            LoginedUser.sharedInstance.mail = NSUserDefaults.standardUserDefaults().objectForKey("mail") as? String
            LoginedUser.sharedInstance.job = NSUserDefaults.standardUserDefaults().objectForKey("job") as? String
            LoginedUser.sharedInstance.sig = NSUserDefaults.standardUserDefaults().objectForKey("sig") as? String
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    
        return true
    }


}

