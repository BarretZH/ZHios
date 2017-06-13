//
//  AppDelegate.h
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "UMSocialControllerService.h"
#import "LeftSlideViewController.h"
#import "SMNavigationController.h"

//#define UmengAppkey @"5715dbcae0f55a874a000ba1"//测试版
#define UmengAppkey @"574e47a9e0f55a1201000bae"//正式版

//测试版使用
//#define WXAppId @"wx7547991640e7b99d"
//#define weixinSecret @"c2cea7a302610395667b91a6671d925e"
//#define sinaAppKey @"2063913514"
//#define sinaSecret @"70c4a305160d666edbfe225fc01818e9"
//#define FacebookAppID @"1532975697002374"

//正式版使用
#define WXAppId @"wx358ff657c8c6cb3b"
#define weixinSecret @"9b2f4d77f9165fb0b67921301d780d94"
#define sinaAppKey @"3560629422"
#define sinaSecret @"70c4a305160d666edbfe225fc01818e9"
#define FacebookAppID @"514855298661044"
#define FacebookSecret @"c8e6ad1b30619ac0083b60d88c5df6f8"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) SMNavigationController *mainNavigationController;
-(void)gotoHomeViewController;
- (void)reDrawAllUIForLanguage:(NSString *)language;
//-(void)versionUpdate;
- (void)GetUserSyncData;
@end

