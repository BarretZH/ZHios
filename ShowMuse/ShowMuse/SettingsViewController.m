//
//  SettingsViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "SDImageCache.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
//#import "SettingsNetWork.h"
#import "CourseDetailsWebViewController.h"
#import "TokenManager.h"
#import "ShowMuseURLString.h"
#import "SMDialog.h"
#import "AFNetworking.h"
#import "UserBadgesModel.h"
#import "UIImageView+WebCache.h"
#import "PopupModel.h"
#import "YGMasterMainViewController.h"
#import "MBProgressHUD.h"
#import "PiwikTracker.h"

#import "YGBecomeTeacherController.h"

#import "LanguageViewController.h"

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray * titleArray;
    int j;
}

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

@implementation SettingsViewController

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

- (NSMutableArray *)dialogArr
{
    if (!_dialogArr) {
        _dialogArr = [NSMutableArray array];
    }
    return _dialogArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = NSLocalizedString(@"LEFT_MENU_SETTINGS", nil);
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;

    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL isAPP_store = [[userDefaults objectForKey:@"atAs"] boolValue];
//    if (isAPP_store||[TokenManager getGuest]) {
//        //隐藏优惠码
//        titleArray = @[NSLocalizedString(@"SYSTEM_SETTINGS_SUBTITLE", nil),
//                       /*@"自动播放",*/
//                       NSLocalizedString(@"SYSTEM_SETTINGS_CLEAR_CACHE", nil),
//                       NSLocalizedString(@"SYSTEM_SETTINGS_RATE_THIS_APP", nil),
//                       NSLocalizedString(@"SYSTEM_SETTINGS_USER_FEEDBACK", nil),
//                       NSLocalizedString(@"SYSTEM_SETTINGS_TERMS_CONDITIONS", nil),
//                       NSLocalizedString(@"SYSTEM_SETTINGS_VERSION", nil),
//                       @""];
//    }else {
        //显示优惠码
    
    
    if ([[userDefaults objectForKey:@"user_sync_guest"] boolValue]) {
        [self.bottomButton setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
    }else {
        [self.bottomButton setTitle:NSLocalizedString(@"SYSTEM_SETTINGS_LOGOUT", nil) forState:UIControlStateNormal];
    }
    [self.bottomButton addTarget:self action:@selector(quitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleArray = @[NSLocalizedString(@"SYSTEM_SETTINGS_SUBTITLE", nil),
                       NSLocalizedString(@"SYSTEM_SETTINGS_AUTO_PLAY", nil),
                       NSLocalizedString(@"SYSTEM_SETTINGS_CLEAR_CACHE", nil),
                       /*NSLocalizedString(@"SYSTEM_SETTINGS_PROMOTIONAL_CODE", nil)*/[[NSUserDefaults standardUserDefaults] valueForKey:@"teacher_title"],
                       NSLocalizedString(@"SYSTEM_SETTINGS_RATE_THIS_APP", nil),
                       NSLocalizedString(@"SYSTEM_SETTINGS_USER_FEEDBACK", nil),
                       NSLocalizedString(@"SYSTEM_SETTINGS_TERMS_CONDITIONS", nil),
                       NSLocalizedString(@"SYSTEM_SETTINGS_LANGUAGE", nil),
                       NSLocalizedString(@"SYSTEM_SETTINGS_VERSION", nil)/*,
                       @""*/];
//    }
    j = 2;
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetUserSyncData) name:SMSettingsViewGetCodeNotification object:nil];
    
    
}


#pragma mark - 表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    SettingsTableViewCell * cell = nil;
    if (indexPath.row < j) {
        //字幕显示选项
        static NSString * str = @"cell0";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
        int isON = 0;
        cell.subtitleSwitch.tag = indexPath.row;
        if (indexPath.row == 0) {
            isON = [[userDefaults objectForKey:@"video_subtitles_on"] intValue];
        }
        if (indexPath.row == 1) {
            isON = [[userDefaults objectForKey:@"isContinuous"] intValue];
        }
        if (isON == 0) {
            cell.subtitleSwitch.on = NO;
        }else {
            cell.subtitleSwitch.on = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.subtitleSwitch addTarget:self action:@selector(subtitleSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.subtitleLabel.text = titleArray[indexPath.row];
    }else if (indexPath.row == j) {
        //清除缓存
        static NSString * str = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:nil options:nil]objectAtIndex:1];
        }
        cell.cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",[[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
        cell.buildIDLabel.text = titleArray[indexPath.row];
    }/*else if (indexPath.row == titleArray.count-1) {
        //登录/登出按钮
        static NSString * str = @"cell3";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:nil options:nil]objectAtIndex:3];
        }
        if ([[userDefaults objectForKey:@"user_sync_guest"] boolValue]) {
            //变登录按钮
            [cell.quitButton setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
        }else {
            [cell.quitButton setTitle:NSLocalizedString(@"SYSTEM_SETTINGS_LOGOUT", nil) forState:UIControlStateNormal];
        }
        [cell.quitButton addTarget:self action:@selector(quitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }*/else if(indexPath.row == titleArray.count-1) {
        //版本
        static NSString * str = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:nil options:nil]objectAtIndex:1];
        }
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];//获取当前版本
        NSString * userBuild = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString * userBuild = [userDefaults objectForKey:@"APPversion"];
        cell.cacheLabel.text = userBuild;
        cell.buildIDLabel.text = titleArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        //带箭头的
        static NSString * str = @"cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingsTableViewCell" owner:nil options:nil]objectAtIndex:2];
        }
        cell.titleLabel.text = titleArray[indexPath.row];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == titleArray.count-1) {
//        return 68;
//    }else {
        return 48;
//    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == j) {
        [self showAlertViewWithMessage:[NSString stringWithFormat:@"%@?",NSLocalizedString(@"SYSTEM_SETTINGS_CLEAR_CACHE", nil)] Title:nil];
    }
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL isAPP_store = [[userDefaults objectForKey:@"atAs"] boolValue];
//    if (isAPP_store||[TokenManager getGuest]) {
//        //在审核
//        if (indexPath.row == j+1) {
//            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1013698709&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
//            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        }
//        if (indexPath.row == j+2) {
//            CourseDetailsWebViewController * VC = [[CourseDetailsWebViewController alloc] init];
//            VC.titleStr = NSLocalizedString(@"SYSTEM_SETTINGS_USER_FEEDBACK", nil);
//            NSString * urlStr = [NSString stringWithFormat:@"%@?access_token=%@",[ShowMuseURLString URLStringWithPath:@"/v2/app/feedback"],[TokenManager getToken]];
//            VC.urlStr = urlStr;
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//        if (indexPath.row == j+3) {
//            CourseDetailsWebViewController * VC = [[CourseDetailsWebViewController alloc] init];
//            VC.titleStr = NSLocalizedString(@"SYSTEM_SETTINGS_TERMS_CONDITIONS", nil);
//            VC.urlStr = [ShowMuseURLString URLStringWithPath:@"/v2/app/terms"];
//            [self.navigationController pushViewController:VC animated:YES];
//        }
//    }else {
        //审核完成
        if (indexPath.row == j+1) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SYSTEM_SETTINGS_PROMOTIONAL_CODE_ALERTVIEW_TITLE", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
//            alertView.tag = 500;
//            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//            UITextField * tf = [alertView textFieldAtIndex:0];
//            tf.borderStyle = UITextBorderStyleNone;
//            tf.placeholder = NSLocalizedString(@"SYSTEM_SETTINGS_PROMOTIONAL_CODE_ALERTVIEW_TITLE", nil);
//            [alertView show];
            YGBecomeTeacherController *bTVc = [[YGBecomeTeacherController alloc] init];
            [self.navigationController pushViewController:bTVc animated:YES];
        }
        if (indexPath.row == j+2) {
            NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1013698709&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        if (indexPath.row == j+3) {
            CourseDetailsWebViewController * VC = [[CourseDetailsWebViewController alloc] init];
            VC.titleStr = NSLocalizedString(@"SYSTEM_SETTINGS_USER_FEEDBACK", nil);
            NSString * urlStr = [NSString stringWithFormat:@"%@?access_token=%@",[ShowMuseURLString URLStringWithPath:@"/v2/app/feedback"],[TokenManager getToken]];
            VC.urlStr = urlStr;
            [self.navigationController pushViewController:VC animated:YES];
        }
        if (indexPath.row == j+4) {
            CourseDetailsWebViewController * VC = [[CourseDetailsWebViewController alloc] init];
            VC.titleStr = NSLocalizedString(@"SYSTEM_SETTINGS_TERMS_CONDITIONS", nil);
            VC.urlStr = [ShowMuseURLString URLStringWithPath:@"/v2/app/terms"];
            [self.navigationController pushViewController:VC animated:YES];

        }
        if (indexPath.row == j+5) {
            LanguageViewController * VC = [[LanguageViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



#pragma mark - 是否显示字幕
-(void)subtitleSwitchClick:(UISwitch *)swich {
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString * video_subtitles_on = @"";
    if (swich.tag == 0) {
        //显示字幕
        if (swich.on) {
            video_subtitles_on = @"1";
        }else {
            video_subtitles_on = @"0";
        }
        NSDictionary * requestParameters = @{@"video_subtitles_on":video_subtitles_on};
//        [SettingsNetWork userSettingsDictionary:requestParameters Complete:^(id json, NSError *error) {
//            if (error == nil) {
//                [userDefaults setObject:video_subtitles_on forKey:@"video_subtitles_on"];
//                [userDefaults synchronize];
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }];
        [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/settings"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [userDefaults setObject:video_subtitles_on forKey:@"video_subtitles_on"];
            [userDefaults synchronize];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SMNavigationController modalGlobalLoginViewController];
        }];
    }
    if (swich.tag == 1) {
        //连续播放
        NSString * isContinuous;
        if (swich.on) {
            //允许连续播放
            isContinuous = @"1";
        }else {
            isContinuous = @"0";
        }
        NSDictionary *requestParameters = @{@"auto_play_on_wifi":isContinuous};
//        [SettingsNetWork userSettingsDictionary:requestParameters Complete:^(id json, NSError *error) {
//            SMLog(@"%@------------->>>%@",json,error);
//        }];
        [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/settings"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [userDefaults setObject:isContinuous forKey:@"isContinuous"];
        [userDefaults synchronize];
    }
}



#pragma mark - 退出登录
-(void)quitButtonClick:(UIButton *)sender {
    
//    [SettingsNetWork logOutWithComplete:^(id json, NSError *error) {
//
//        if (error == nil) {
//        }
//    }];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/logout"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"access_token"];
    [userDefaults removeObjectForKey:@"guest"];
    [userDefaults synchronize];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginViewController * VC = /*[LoginViewController sharedLoginController]*/[[LoginViewController alloc] init];
    VC.loginSucc = ^ {
        [tempAppDelegate gotoHomeViewController];
    };
    SMNavigationController *LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
    LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    tempAppDelegate.window.rootViewController = LoginNav;
//    [self presentViewController:LoginNav animated:YES completion:nil];
    [PiwikTracker sharedInstance].userID = nil;
    
}


#pragma mark - 返回
-(void)goBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - 提示框
-(void)showAlertViewWithMessage:(NSString *)message Title:(NSString *)title {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
    alertView.tag = 100;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [[SDImageCache sharedImageCache] clearDisk];
            [_tableView reloadData];
        }
    }
    if (alertView.tag == 500) {
        if (buttonIndex == 1) {
            UITextField * tf = [alertView textFieldAtIndex:0];
            
            NSString * str = [tf.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (![str isEqualToString:@""]) {
                SMLog(@"111111");
//                [SettingsNetWork redeemCodeShopWith:str Complete:^(id json, NSError *error) {
//                    SMLog(@"youhuima---%@-----%@--------%@",str,error,json);
//                    if (error == nil) {
//                        int code = [json[@"code"] intValue];
//                        if (code == 200) {
//                            
//                            MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            notice.mode = MBProgressHUDModeText;
//                            notice.labelText = json[@"message"];
//                            notice.yOffset = -40;
//                            [notice hide:YES afterDelay:4.0];
//                            i = 0; // 将计数器清0
//                            [self GetUserSyncData];
//                            
//                        }
//                        if (code == 400) {
//                            MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                            notice.mode = MBProgressHUDModeText;
//                            notice.labelText = json[@"message"];
//                            notice.yOffset = -40;
//                            [notice hide:YES afterDelay:4.0];
//                        }
//                    }
//                }];
            }else {
                SMLog(@"000000");
            }
        }
    }
}

#pragma mark - user sync的相关方法
/**
 *  user sync
 */
- (void)GetUserSyncData
{
    [self.dialogArr removeAllObjects];
    NSString *urlStr = [ShowMuseURLString URLStringWithPath:@"/v2/user/sync"];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [self.manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    params[@"badge"] = @(1);
    params[@"popup"] = @(1);
    [self.manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SMLog(@"--- responseObject --- > %@", responseObject);
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
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.view.userInteractionEnabled = NO;
    self.navigationController.view.userInteractionEnabled = NO;
    [keyWindow addSubview:dialog];
}

#pragma mark - SMDialogDelegate
static int i = 0;
- (void)dialogCloseBtnDidClick:(UIButton *)button
{
    if (i < self.dialogArr.count) {
        // 删除view
        SMDialog *dialog = [self.dialogArr objectAtIndex:i];
        [dialog removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        self.navigationController.view.userInteractionEnabled = YES;
        i++;
        if (i <= self.dialogArr.count - 1) {
            // 加View
            SMDialog *dialogNext = [self.dialogArr objectAtIndex:i];
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:dialogNext snapToPoint:CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.39)];
            [self.anim addBehavior:snap];
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            self.navigationController.view.userInteractionEnabled = NO;
            self.view.userInteractionEnabled = NO;
            [keyWindow addSubview:dialogNext];
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
        if (self.goToUrl) {
            [self.dialog removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            self.navigationController.view.userInteractionEnabled = YES;
            CourseDetailsWebViewController *cDWVC = [[CourseDetailsWebViewController alloc] init];
            cDWVC.titleStr = self.badge.gotoUrlTitle;
            cDWVC.urlStr = self.badge.gotoUrl;
            [self.navigationController pushViewController:cDWVC animated:YES];
        }
    } else { // 去大师主页
        [self.dialog removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        self.navigationController.view.userInteractionEnabled = YES;
        YGMasterMainViewController *mMVC = [[YGMasterMainViewController alloc] init];
        mMVC.teacherID = [NSString stringWithFormat:@"%d", self.badge.teacherID];
        [self.navigationController pushViewController:mMVC animated:YES];
    }
}


@end
