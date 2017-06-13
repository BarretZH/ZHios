//
//  AppDelegate.m
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "LaunchViewController.h"
#import "MainNetWorking.h"
#import "Launch.h"
#import "HomeViewController.h"
#import "LeftSortsViewController.h"
#import "TokenManager.h"
#import "SystemMessages.h"
#import "WXApi.h"
//#import "WXApiManager.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "CoursesDetailsViewController.h"
#import "CourseViewController.h"
#import "YGMasterMainViewController.h"
#import "CourseDetailsWebViewController.h"
#import "UserPageViewController.h"
#import "VIPShopViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import "ShowMuseURLString.h"
#import "PiwikTracker.h"
#import "ACTReporter.h"
#import "SMDialog.h"
#import "UserBadgesModel.h"
#import "PopupModel.h"
#import "UIImageView+WebCache.h"

#import "SMLessonDetailController.h"
#import <AdSupport/AdSupport.h>

//static NSString * const PiwikServerURL = @"http://stat.showmuse.so/";
//static NSString * const PiwikSiteID = @"4";

@interface AppDelegate ()<WXApiDelegate,SMDialogDelegate, JPUSHRegisterDelegate>
//
/** 弹框动画 */
@property (strong, nonatomic) UIDynamicAnimator *anim;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
/** badge模型 */
@property (strong, nonatomic) UserBadgesModel *badge;
/** 记录徽章观看进度 */
@property (assign, nonatomic) NSInteger watchProgress;
/** dialog */
@property (weak, nonatomic) SMDialog *dialog;
/** 保存所有创建的对话框 */
@property (strong, nonatomic) NSMutableArray *dialogArr;
/** 保存所有popup模型 */
@property (strong, nonatomic) NSMutableArray *popupArr;
/** 记录goToUrl */
@property (copy, nonatomic) NSString *goToUrl;

@end

@implementation AppDelegate
- (NSMutableArray *)dialogArr
{
    if (!_dialogArr) {
        _dialogArr = [NSMutableArray array];
    }
    return _dialogArr;
}
- (UIDynamicAnimator *)anim
{
    if (!_anim) {
        _anim = [[UIDynamicAnimator alloc] init];
    }
    return _anim;
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return _manager;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
     [application setStatusBarOrientation:UIInterfaceOrientationPortrait];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [PiwikTracker sharedInstanceWithSiteID:PiwikSiteID baseURL:[NSURL URLWithString:PiwikServerURL]];
    
    [PiwikTracker sharedInstance].debug = NO;
    [PiwikTracker sharedInstance].dispatchInterval = 20;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    } else {
        //[Required] 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    //Required
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPP_KEY channel:@"App Store" apsForProduction:NO advertisingIdentifier:nil];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //添加AdWords 转化跟踪
    [ACTAutomatedUsageTracker enableAutomatedUsageReportingWithConversionID:@"873719899"];
    [ACTConversionReporter reportWithConversionID:@"873719899" label:@"pR57CMuykmoQ29DPoAM" value:@"0.00" isRepeatable:NO];
    
    [ShareSDK registerApp:@"1244a75bd9bcb"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeFacebook),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWhatsApp)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
//             case SSDKPlatformTypeRenren:
//                 [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:sinaAppKey
                                           appSecret:sinaSecret
                                         redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WXAppId
                                       appSecret:weixinSecret];
                 break;
             case SSDKPlatformTypeFacebook:
                 [appInfo SSDKSetupFacebookByApiKey:FacebookAppID appSecret:FacebookSecret authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
/** *************************************************************************************************************************************** */
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {

        //判断版本
        [self versionUpdate];
    
    LaunchViewController *launchVC = [[LaunchViewController alloc] init];
        launchVC.launchSucc = ^{
            [self gotoHomeViewController];
        };
        
    _window.rootViewController = launchVC;
        
    } else {
        
        [self versionUpdate];
        [self usergotoViewController];
        
    }
    
    [WXApi registerApp:WXAppId withDescription:@"ShowMuse"];
    return YES;
}

#pragma mark - 进入主页
//去主页
-(void)gotoHomeViewController {
    
    
//    [self userData];
    HomeViewController *mainVC = [[HomeViewController alloc] init];
    self.mainNavigationController = [[SMNavigationController alloc] initWithRootViewController:mainVC];
    self.mainNavigationController.view.backgroundColor = colorWithRGB(109, 217, 240);
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    self.window.rootViewController = _LeftSlideVC;

}

//游客的主页
-(void)guestLoginGotoHomeViewController {
    HomeViewController *mainVC = [[HomeViewController alloc] init];
    SMNavigationController * naVC = [[SMNavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = naVC;
}


#pragma mark - 获取用户信息
-(void)userData {

    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    
    NSString * jpushID = [JPUSHService registrationID];//获取极光的registrationID
    if (jpushID == nil) {
        jpushID = @"";
    }else {
    }
    NSDictionary* requestParameters = @{@"deviceId":identifierStr,@"jpushId":jpushID};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/sync"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject;
        [TokenManager saveUserdataWithDictionary:dic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 判断版本更新
-(void)versionUpdate {
    [MainNetWorking versionID];
    [MainNetWorking  versionUpdateComplete:^(id json, NSError *error) {
        SMLog(@"-------版本更新请求---------%@-------%@",json,error);
        if (json) {
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL as = [json[@"atAs"] boolValue];
            BOOL guest_allowed = [json[@"guest_allowed"] boolValue];
            BOOL guestAsUser = [json[@"guestAsUser"] boolValue];
            BOOL videoDownloads_enable = [json[@"videoDownloads"][@"enable"] boolValue];
//            videoDownloads_enable = YES;
            [userDefaults setBool:as forKey:@"atAs"];
            [userDefaults setBool:guest_allowed forKey:@"guest_allowed"];
            [userDefaults setBool:guestAsUser forKey:@"guestAsUser"];
            [userDefaults setObject:json[@"host"] forKey:@"URL_HOST"];
            [userDefaults setObject:json[@"system_messages"][@"40302"] forKey:@"40302"];
            [userDefaults setObject:json[@"system_messages"][@"40301"] forKey:@"40301"];
            [userDefaults setInteger:[json[@"videoDownloads"][@"limit"] integerValue] forKey:@"downloadLimit"];
            [userDefaults setBool:videoDownloads_enable forKey:@"videoDownloads_enable"];
            [userDefaults synchronize];
            [[LoginViewController sharedLoginController] showSkipButton];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"appPreferences" object:nil];
            NSArray * version_update = json[@"version_update"];
            //        if (error == nil) {
            if (version_update.count > 0) {
                NSDictionary * versionDic = version_update[0];
                BOOL isMandatory = [versionDic[@"isMandatory"] boolValue];
                if (isMandatory) {
                    //必须
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:versionDic[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
                    alertView.tag = 100;
                    [alertView show];
                }else {
                    //可选
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:versionDic[@"message"] delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
                    alertView.tag = 200;
                    [alertView show];
                }
            }

        }else {
            [SMNavigationController modalGlobalLoginViewController];
        }
        

    }];
}

-(void)usergotoViewController {
    //判断用户是否登录
    if ([TokenManager getToken]) {
        if ([TokenManager getGuest]) {
            //游客   [[[UIDevice currentDevice] identifierForVendor] UUIDString]
            //                [self guestLoginGotoHomeViewController];
            [self gotoHomeViewController];
        }else {
            //                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            //                NSString * user_id = [userDefaults objectForKey:@"user_ID"];
            [self gotoHomeViewController];
        }
        
    }else {
        LoginViewController * VC = [LoginViewController sharedLoginController];
        VC.loginSucc = ^{
            [self gotoHomeViewController];
        };
        SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
        _window.rootViewController = LoginNav;
    }

}

#pragma mark - 判断用户是否登录
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[PiwikTracker sharedInstance] sendCampaign:[url absoluteString]];
    SMLog(@"jpush----%@",[url host]);
    // deeplink jump to
    if ([[url host] isEqualToString:@"page"]) {
        
        [self jumpToDifferentPageWithURL:url];
    }

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * str= [userDefaults objectForKey:@"weixinpay"];
    if ([str isEqualToString:@"weixin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else {
//        return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}
//微信支付回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    // deeplink jump to
    if ([[url host] isEqualToString:@"page"]) {
        [self jumpToDifferentPageWithURL:url];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}
/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    [UMSocialSnsService  applicationDidBecomeActive];
    
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            NSString *str = @"https://itunes.apple.com/hk/app/showmuse-learn-freedom-fun/id1013698709?l=zh&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }else {
        NSString *str = @"https://itunes.apple.com/hk/app/showmuse-learn-freedom-fun/id1013698709?l=zh&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)onResp:(BaseResp *)resp
{
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
//                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"成功"];
                break;
                
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weixin_pay_result" object:@"失败"];
                break;
        }
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

// 接受远程通知调用方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
    NSURL *url = [NSURL URLWithString:userInfo[@"deeplink"]];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        [self application:application openURL:url options:nil];
    } else {
        [self application:application openURL:url sourceApplication:nil annotation:nil];
    }
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    
}
#pragma mark- JPUSHRegisterDelegate // 2.1.9版新增JPUSHRegisterDelegate,需实现以下两个方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)  (NSInteger))completionHandler {
    
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSURL *url = [NSURL URLWithString:userInfo[@"deeplink"]];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self jumpToDifferentPageWithURL:url]; // deplink
    }
    completionHandler();  // 系统要求执行这个方法
}
#pragma mark - deeplink
- (void)jumpToDifferentPageWithURL:(NSURL *)url
{
    SMNavigationController *nav = (SMNavigationController *)self.mainNavigationController;
    NSArray *components = [[url path] componentsSeparatedByString:@"/"];
    NSString *pathStr = [components objectAtIndex:1];
    
    if ([pathStr isEqualToString:@"lessons"]) { // 该课程详情页
        NSString *lessonID = [components lastObject];
//        CoursesDetailsViewController *cDetailVC = [[CoursesDetailsViewController alloc] init];
//        cDetailVC.lessonID = lessonID;
//        [nav pushViewController:cDetailVC animated:YES];
        
        SMLessonDetailController *detailVc = [[SMLessonDetailController alloc] init];
        detailVc.lessonID = lessonID;
        [nav pushViewController:detailVc animated:YES];
    } else if ([pathStr isEqualToString:@"courses"]) { // 课程包
        if (components.count == 3) {
            NSString *courseID = [components lastObject];
            CourseViewController *cVC = [[CourseViewController alloc] init];
            cVC.ID = courseID;
            [nav pushViewController:cVC animated:YES];
        } else if (components.count == 5) {
            // showmuse://  page / courses / {id} / lessons-group / {groupId}       groupId - is 0 or 1 or 2
            
        }
    } else if ([pathStr isEqualToString:@"teachers"]) { // 大师页面
        if (components.count == 3) { // 大师详情主页
            NSString *teacherID = [components lastObject];
            YGMasterMainViewController *mmVc = [[YGMasterMainViewController alloc] init];
            mmVc.teacherID = teacherID;
            [nav pushViewController:mmVc animated:YES];
        }
    } else if ([pathStr isEqualToString:@"user"]) { // 用户页面
        NSString *lastStr = [components lastObject];
        
        if ([lastStr isEqualToString:@"messages"]) { // 消息
            CourseDetailsWebViewController *msgVC = [[CourseDetailsWebViewController alloc] init];
            msgVC.titleStr = NSLocalizedString(@"LEFT_MENU_MESSAGE", nil);
            msgVC.isdeeplink = YES;
            msgVC.urlStr = [NSString stringWithFormat:@"%@?access_token=%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/messages"], [TokenManager getToken]];
            [nav pushViewController:msgVC animated:YES];
        } else if ([lastStr isEqualToString:@"lessons"]) { // 课程
            UserPageViewController *uPVC = [[UserPageViewController alloc] init];
            uPVC.deeplink = YES;
            uPVC.numberID = 100;
            [nav pushViewController:uPVC animated:YES];
        } else if ([lastStr isEqualToString:@"badges"]) { // 徽章
            UserPageViewController *uPVC = [[UserPageViewController alloc] init];
            uPVC.deeplink = YES;
            uPVC.numberID = 200;
            [nav pushViewController:uPVC animated:YES];
            
        } else if ([lastStr isEqualToString:@"subscriptions"]) { // 消费记录
            UserPageViewController *uPVC = [[UserPageViewController alloc] init];
            uPVC.deeplink = YES;
            uPVC.numberID = 300;
            [nav pushViewController:uPVC animated:YES];
        }
        
    } else if ([pathStr isEqualToString:@"shop"]) { // 购买套餐
        VIPShopViewController *vipVC = [[VIPShopViewController alloc] init];
        [nav pushViewController:vipVC animated:YES];
    }
}

#pragma mark - 极光推送的通知方法
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
//    SMLog(@"------------jpush-->>%@",userInfo);
    if ([extras[@"type"] isEqualToString:@"doUserSync"]) {
        [self GetUserSyncData];
    }
    
}

/**
 *  user sync
 */
- (void)GetUserSyncData
{
    i = 0;
    [self.dialogArr removeAllObjects];
    NSString *urlStr = [ShowMuseURLString URLStringWithPath:@"/v2/user/sync"];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [self.manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    params[@"badge"] = @(1);
    params[@"popup"] = @(1);
    [self.manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [TokenManager saveUserdataWithDictionary:responseObject];
//        [self.tableView reloadData];
//        SMLog(@"--- responseObject --- > %@", responseObject);
        // 徽章
        NSDictionary *badgeDict = [responseObject[@"badges"] firstObject];
        if (badgeDict) {
            UserBadgesModel *badge = [[UserBadgesModel alloc] initWithDictionary:badgeDict];
            self.badge = badge;
            NSURL *url = [NSURL URLWithString:badge.img];
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (badge.progress == 100) {
                    [self addBadgeDialogWithModel:badge image:imageView.image colorWithR:65 g:198 b:228];
                } else {
                    [self addBadgeDialogWithModel:badge image:imageView.image colorWithR:225 g:96 b:75];
                }
                // popup消息
                [self addPopupDialogWithData:responseObject];
            }];
        } else {
            [self addPopupDialogWithData:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

/**
 *  添加徽章dialog
 */
- (void)addBadgeDialogWithModel:(UserBadgesModel *)badge image:(UIImage *)image colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    self.watchProgress = badge.progress;
    self.goToUrl = badge.gotoUrl;
    SMDialog *dialog = [[SMDialog alloc] initWithImage:image contentText:badge.progressDescription delegate:self leftButtonTitle:nil rightButtonTitle:badge.progressPopupBtnTitle];
    dialog.rightButton.backgroundColor = colorWithRGB(r, g, b);
    self.dialog = dialog;
    [self.dialogArr addObject:dialog];
    [self addDialogToScreenWithUIDynamicItemName:dialog dialog:dialog];
}

// 添加popup对话框
- (void)addPopupDialogWithData:(id)responseObject
{
    if (!responseObject[@"popup"]) return;
    for (NSDictionary *popupDict in responseObject[@"popup"]) {
        PopupModel *popup = [PopupModel PopupWithDict:popupDict];
        [self.popupArr addObject:popup];
        
        if ([popup.contentType isEqualToString:@"text"]) { // 纯文字
            SMDialog *textDialog = [[SMDialog alloc] initWithTitle:nil  content:popup.content delegate:self leftButtonTitle:@"OK" rightButtonTitle:nil];
            [self.dialogArr addObject:textDialog];
            if (self.dialogArr.count == 1) {
                [self addDialogToScreenWithUIDynamicItemName:textDialog dialog:textDialog];
            }
            
        } else if ([popup.contentType isEqualToString:@"url"]) { // url
            SMDialog *urlDialog = [[SMDialog alloc] initWithTitle:nil htmlString:popup.content delegate:self leftbuttonTitle:@"OK" rightButtonTitle:nil];
            [self.dialogArr addObject:urlDialog];
            if (self.dialogArr.count == 1) {
                [self addDialogToScreenWithUIDynamicItemName:urlDialog dialog:urlDialog];
            }
            
        } else if ([popup.contentType isEqualToString:@"html"]) { // html
            SMDialog *htmlDialog = [[SMDialog alloc] initWithTitle:nil htmlString:popup.content delegate:self leftbuttonTitle:@"OK" rightButtonTitle:nil];
            [self.dialogArr addObject:htmlDialog];
            if (self.dialogArr.count == 1) {
                [self addDialogToScreenWithUIDynamicItemName:htmlDialog dialog:htmlDialog];
            }
        }
    }
}

/**
 *  添加一个对话框到屏幕上
 */
- (void)addDialogToScreenWithUIDynamicItemName:(id)UIDynamicItemName dialog:(SMDialog *)dialog
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:UIDynamicItemName snapToPoint:CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.39)];
    [self.anim addBehavior:snap];
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    self.view.userInteractionEnabled = NO;
//    self.navigationController.view.userInteractionEnabled = NO;
    self.mainNavigationController.view.userInteractionEnabled = NO;
    [self.window addSubview:dialog];
}

#pragma mark - SMDialogDelegate
static int i = 0;
- (void)dialogCloseBtnDidClick:(UIButton *)button
{
    if (i < self.dialogArr.count) {
        // 删除view
        SMDialog *dialog = [self.dialogArr objectAtIndex:i];
        [dialog removeFromSuperview];
//        self.view.userInteractionEnabled = YES;
//        self.navigationController.view.userInteractionEnabled = YES;
        self.mainNavigationController.view.userInteractionEnabled = YES;
        i++;
        if (i <= self.dialogArr.count - 1) {
            // 加View
            SMDialog *dialogNext = [self.dialogArr objectAtIndex:i];
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:dialogNext snapToPoint:CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.39)];
            [self.anim addBehavior:snap];
//            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//            self.navigationController.view.userInteractionEnabled = NO;
//            self.view.userInteractionEnabled = NO;
            self.mainNavigationController.view.userInteractionEnabled = NO;
            [self.window addSubview:dialogNext];
        }
    }
}
// popup
- (void)dialogLeftButtonDidClick:(UIButton *)button
{
    [self dialogCloseBtnDidClick:button];
}
// 徽章点击
- (void)dialogRightButtonDidClick:(UIButton *)button
{

    
    if (self.watchProgress == 100) { // 获得徽章
        
        if (![self.goToUrl isEqualToString:@""]) {
            [self.dialog removeFromSuperview];
            CourseDetailsWebViewController *cDWVC = [[CourseDetailsWebViewController alloc] init];
            cDWVC.titleStr = self.badge.gotoUrlTitle;
            cDWVC.urlStr = self.badge.gotoUrl;
            [(SMNavigationController *)self.mainNavigationController pushViewController:cDWVC animated:YES];
        }else {
            [self dialogCloseBtnDidClick:button];
        }
    } else { // 去大师主页
        [self.dialog removeFromSuperview];
        YGMasterMainViewController *mMVC = [[YGMasterMainViewController alloc] init];
        mMVC.teacherID = [NSString stringWithFormat:@"%d", self.badge.teacherID];
        [(SMNavigationController *)self.mainNavigationController pushViewController:mMVC animated:YES];
    }
}


#pragma mark - 切换语言的的时候调用的方法
- (void)reDrawAllUIForLanguage:(NSString *)language {
    [[ACLanguageUtil sharedInstance] setLanguage:language];
    
    self.window.rootViewController = nil;
    [self gotoHomeViewController];
}

@end
