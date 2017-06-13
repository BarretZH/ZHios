//
//  LeftSortsViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/4.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "YGBecomeTeacherController.h"
#import "UserPageViewController.h"
#import "CourseDetailsWebViewController.h"
#import "ShowMuseURLString.h"
#import "TokenManager.h"
#import "SettingsViewController.h"
#import "VIPShopViewController.h"
#import "LeftTableViewCell.h"
//#import "HomeNetWork.h"
#import "CategoriesModel.h"
#import "UIImageView+WebCache.h"
#import "CategoriesViewController.h"
#import "LoginViewController.h"
//#import "MainNetWorking.h"
#import "JPUSHService.h"
#import "SMDownloadController.h"

//#import "SettingsNetWork.h"
#import "MBProgressHUD.h"
#import "SMDialog.h"
#import "UserBadgesModel.h"
#import "PopupModel.h"
#import "YGMasterMainViewController.h"
#import "RegisterViewController.h"

@interface LeftSortsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIButton * bagBtn;

@property (strong, nonatomic) NSMutableArray * categorArray;

@property (nonatomic) int enableDownload;
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


@property (nonatomic) BOOL showDownload;
@property (nonatomic) BOOL showPromotionalCode;

@end

@implementation LeftSortsViewController
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
    _categorArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _enableDownload = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showmuse) name:@"userData" object:nil];
}


#pragma mark - 成为老师
- (IBAction)becomeTeacherBtn {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    YGBecomeTeacherController *bTVc = [[YGBecomeTeacherController alloc] init];
    [delegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    [delegate.mainNavigationController pushViewController:bTVc animated:YES];
    
}



-(void)showmuse {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    SMLog(@"***********%@",self.tableView);
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        float height = self.tableView.frame.size.height;
//    });
    
    [self.registerBtn.layer setBorderWidth:1.0];
    self.registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.loginBtn.layer setBorderWidth:1.0];
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    if ([[userDefaults objectForKey:@"user_sync_guest"] boolValue]) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SMScreenHeight-243-50)];
        self.botView.alpha = 1;
    }else {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SMScreenHeight-243)];
        self.botView.alpha = 0;
    }
    [self.registerBtn setTitle:NSLocalizedString(@"REGISTRATION", nil) forState:UIControlStateNormal];
    [self.loginBtn setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
    
    
//    NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    NSString * path = [NSString stringWithFormat:@"%@/Caregories.plist",pathDir];
//    self.categorArray = [[[NSMutableArray alloc] initWithContentsOfFile:path] copy];
////    self.categorArray = arr;
//    SMLog(@"--------%@",self.categorArray);
//    [self.tableView reloadData];

    
    if (![[userDefaults objectForKey:@"onceOpen"] isEqualToString:@"yes"]) {
    
        _bagBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _bagBtn.frame = CGRectMake(0, 0, SMScreenWidth, SMScreenHeight);
        _bagBtn.backgroundColor = colorWithRGBA(0, 0, 0, 0.6);
        [_bagBtn addTarget:self action:@selector(bagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].delegate.window addSubview:_bagBtn];
    
        UIImageView * headImage = [[UIImageView alloc] initWithFrame:self.userButton.frame];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"head"]];
        headImage.layer.cornerRadius = self.userButton.frame.size.height/2;
        headImage.clipsToBounds = YES;
        headImage.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
        [headImage addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTapsRequired:1];

        [_bagBtn addSubview:headImage];
        
        float width = 200;
        UIImageView * tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SMScreenWidth-80)/2-width/2, self.userButton.frame.origin.y+self.userButton.frame.size.height, width, width/2.5)];
        tipImageView.image = [UIImage imageNamed:@"tips"];
        [_bagBtn addSubview:tipImageView];
        
        
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, tipImageView.frame.size.width-10, tipImageView.frame.size.height-17)];
//        textLabel.backgroundColor = [UIColor redColor];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:15.0f];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = NSLocalizedString(@"CLICK_PROFILE_GO_HOMEPAGE", nil);
        [tipImageView addSubview:textLabel];
        
        
        
        [userDefaults setObject:@"yes" forKey:@"onceOpen"];
        [userDefaults synchronize];
    }
    NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString * path = [NSString stringWithFormat:@"%@/catarr.txt",pathDir];

    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if ([[NSFileManager defaultManager] fileExistsAtPath:path]){
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            //        创建反序列化对象
//            NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
//            self.categorArray = [unarchiver decodeObject];
//            SMLog(@"-----显示分类数据----");
//            [self.tableView reloadData];
//        }
//    });
    NSData *data = [NSData dataWithContentsOfFile:path];
    //        创建反序列化对象
    NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    self.categorArray = [unarchiver decodeObject];
    SMLog(@"-----显示分类数据----");
    [self.tableView reloadData];

    
    
//    [HomeNetWork caregoriesComplete:^(id json, NSError *error) {
//        if (json) {
//            if (self.categorArray.count > 0) {
//                [self.categorArray removeAllObjects];
//            }
//            [json enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                CategoriesModel * categories = [[CategoriesModel alloc] initWithDictionary:obj];
//                [self.categorArray addObject:categories];
//            }];
//            if ([[userDefaults objectForKey:@"videoDownloads_enable"] boolValue]) {
//                //显示下载
//                _showDownload = YES;
//            }else {
//                //隐藏下载
//                _showDownload = NO;
//            }
//            if (![[userDefaults objectForKey:@"atAs"] boolValue]) {
//                _showPromotionalCode = YES;
//            }else {
//                _showPromotionalCode = NO;
//            }
//            if (_showPromotionalCode && _showDownload) {
//                _enableDownload = 3;
//            }else if (_showDownload || _showPromotionalCode) {
//                _enableDownload = 2;
//            }
//            SMLog(@"再刷新一次");
//            [self.tableView reloadData];
//        }else {
//            [SMNavigationController modalGlobalLoginViewController];
//        }
//    }];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/categories"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.categorArray.count > 0) {
            [self.categorArray removeAllObjects];
        }
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CategoriesModel * categories = [[CategoriesModel alloc] initWithDictionary:obj];
            [self.categorArray addObject:categories];
        }];
        if ([[userDefaults objectForKey:@"videoDownloads_enable"] boolValue]) {
            //显示下载
            _showDownload = YES;
        }else {
            //隐藏下载
            _showDownload = NO;
        }
        if (![[userDefaults objectForKey:@"atAs"] boolValue]) {
            _showPromotionalCode = YES;
        }else {
            _showPromotionalCode = NO;
        }
        if (_showPromotionalCode && _showDownload) {
            _enableDownload = 3;
        }else if (_showDownload || _showPromotionalCode) {
            _enableDownload = 2;
        }
        SMLog(@"再刷新一次");
        [self.tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
    }];
    [self usersyncNetWork];

    [self.settingButton setTitle:[NSString stringWithFormat:@" %@",NSLocalizedString(@"LEFT_MENU_SETTINGS", nil)] forState:UIControlStateNormal];
    [self.messageButton setTitle:[NSString stringWithFormat:@" %@",NSLocalizedString(@"LEFT_MENU_MESSAGE", nil)] forState:UIControlStateNormal];
    [self.VIPButton setTitle:NSLocalizedString(@"LEFT_MENU_SUBSCRIPTION", nil) forState:UIControlStateNormal];
    [self.teacherButton setTitle:NSLocalizedString(@"LEFT_MENU_TEACHER", nil) forState:UIControlStateNormal];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [_nameLabel setText:[userDefaults objectForKey:@"userName"]];
    [_userButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head"]];

    NSInteger number = [userDefaults integerForKey:@"messagesTotal"];
    if (number > 0) {
        self.messageNumberView.alpha = 1;
        self.messageNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[userDefaults integerForKey:@"messagesTotal"]];
    }else {
        self.messageNumberView.alpha = 0;
    }
    _timeLabel.text = [userDefaults valueForKey:@"premiumTime"];

    UILabel * lab = self.timeLabel;
    lab.text = [userDefaults objectForKey:@"premiumTime"];
    
    // teacher_title
    NSString *teaTitle= [[NSUserDefaults standardUserDefaults] objectForKey:@"teacher_title"];
    [self.teacherButton setTitle:teaTitle forState:UIControlStateNormal];
//    [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height-100)];
}

-(void)usersyncNetWork {
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

#pragma mark - 表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _enableDownload+self.categorArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftTableViewCell * cell = nil;
    if (indexPath.row == 0) {
        static NSString * str = @"cell0";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
        cell.VIPlabel.text = NSLocalizedString(@"LEFT_MENU_SUBSCRIPTION", nil);
        cell.VIPTimeLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"premiumTime"];
    }
    if (_enableDownload == 3) {
        if (indexPath.row == 1) {
            static NSString * str = @"cell2";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftTableViewCell" owner:nil options:nil]objectAtIndex:2];
            }
            //        cell.guruLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"teacher_title"];
            cell.guruLabel.text = NSLocalizedString(@"SYSTEM_SETTINGS_PROMOTIONAL_CODE", nil);
        }
        if (indexPath.row == 2 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"videoDownloads_enable"] boolValue]) {
            static NSString * str = @"cell2";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftTableViewCell" owner:nil options:nil]objectAtIndex:2];
            }
            cell.guruLabel.text = NSLocalizedString(@"LEFT_MENU_DOWNLOAD_MANAGER", nil);
        }
    }
    if (_enableDownload == 2) {
        if (indexPath.row == 1) {
            if (_showDownload) {
                static NSString * str = @"cell2";
                cell = [tableView dequeueReusableCellWithIdentifier:str];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftTableViewCell" owner:nil options:nil]objectAtIndex:2];
                }
                cell.guruLabel.text = NSLocalizedString(@"LEFT_MENU_DOWNLOAD_MANAGER", nil);
            }else {
                static NSString * str = @"cell2";
                cell = [tableView dequeueReusableCellWithIdentifier:str];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftTableViewCell" owner:nil options:nil]objectAtIndex:2];
                }
                //        cell.guruLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"teacher_title"];
                cell.guruLabel.text = NSLocalizedString(@"SYSTEM_SETTINGS_PROMOTIONAL_CODE", nil);
            }
        }
    }
    if(indexPath.row >=_enableDownload) {
        static NSString * str = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftTableViewCell" owner:nil options:nil]objectAtIndex:1];
        }
        if (self.categorArray.count > 0) {
            
            CategoriesModel * categories = self.categorArray[indexPath.row-_enableDownload];
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:categories.iconImg]];
            cell.titleLabel.text = categories.title;
            cell.messagesLabel.text = [NSString stringWithFormat:@"%d",categories.totalNew];
            if (categories.totalNew == 0) {
                cell.messageView.alpha = 0;
            }else {
                cell.messageView.alpha = 1;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        if ([TokenManager getGuest]) {
            //游客
            [self guestAlertView];
        }else {
//            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            VIPShopViewController * VC = [[VIPShopViewController alloc] init];
//            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
//            [tempAppDelegate.mainNavigationController pushViewController:VC animated:NO];
            [self gotoVIPController];
        }
    }
    if (_enableDownload == 3) {
        if(indexPath.row == 1) {
            //        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //        YGBecomeTeacherController *bTVc = [[YGBecomeTeacherController alloc] init];
            //        [delegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            //        [delegate.mainNavigationController pushViewController:bTVc animated:YES];
            [self promotionalCodeClick];
        }
        if(indexPath.row == 2) {
            NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL isVIP = [[userDefaults objectForKey:@"premium"] boolValue];
            if (isVIP) {
                [self gotoDownloadController];
            }else {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_CAN_ONLY_ACCESS_AFTER_SUBSCRIPTION", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
                alertView.tag = 200;
                [alertView show];
            }
            //        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            //        [delegate.LeftSlideVC closeLeftView];
            //        // Download Vc
            //        SMDownloadController *dVc = [[SMDownloadController alloc] init];
            //        [delegate.mainNavigationController pushViewController:dVc animated:YES];
        }
    }
    if (_enableDownload == 2) {
        if (indexPath.row == 1) {
            if (_showDownload) {
                NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
                BOOL isVIP = [[userDefaults objectForKey:@"premium"] boolValue];
                if (isVIP) {
                    [self gotoDownloadController];
                }else {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_CAN_ONLY_ACCESS_AFTER_SUBSCRIPTION", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
                    alertView.tag = 200;
                    [alertView show];
                }
            }else {
                [self promotionalCodeClick];
            }
        }
    }
    if(indexPath.row >=_enableDownload) {
        if (self.categorArray.count > 0) {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            CategoriesModel * categories = self.categorArray[indexPath.row-_enableDownload];
            CategoriesViewController * categoriesVC = [[CategoriesViewController alloc] init];
            categoriesVC.titleStr = categories.title;
            categoriesVC.ID = categories.ID;
            [delegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            [delegate.mainNavigationController pushViewController:categoriesVC animated:YES];
        }
    }
}

#pragma mark - 跳转下载界面
-(void)gotoDownloadController {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.LeftSlideVC closeLeftView];
    // Download Vc
    SMDownloadController *dVc = [[SMDownloadController alloc] init];
    [delegate.mainNavigationController pushViewController:dVc animated:YES];
}
#pragma mark - 跳转vip购买界面
-(void)gotoVIPController {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    VIPShopViewController * VC = [[VIPShopViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    [tempAppDelegate.mainNavigationController pushViewController:VC animated:NO];

}
#pragma mark - 弹出提示框
-(void)guestAlertView {
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString * messageLogin = [userDefaults objectForKey:@"40301"];
    //    NSString * messageVIP = [userDefaults objectForKey:@"40302"];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:messageLogin delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
    alertView.tag = 100;
    [alertView show];
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            LoginViewController * VC = [LoginViewController sharedLoginController];
            VC.loginSucc = ^ {
                [tempAppDelegate gotoHomeViewController];
            };
            SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
            LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            tempAppDelegate.window.rootViewController = LoginNav;
            [self presentViewController:LoginNav animated:YES completion:nil];
        }
    }
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            [self gotoVIPController];
        }
    }
    if (alertView.tag == 500) {
        [self.view endEditing:YES];
        if (buttonIndex == 1) {
            UITextField * tf = [alertView textFieldAtIndex:0];
            
//            NSString * str = [tf.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (![tf.text isEqualToString:@""]) {
//                [SettingsNetWork redeemCodeShopWith:tf.text Complete:^(id json, NSError *error) {
//                    if (error == nil) {
//                        int code = [json[@"code"] intValue];
//                        if (code == 200) {
//                            
//                            MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
//                            notice.mode = MBProgressHUDModeText;
//                            notice.labelText = json[@"message"];
//                            notice.yOffset = -40;
//                            [notice hide:YES afterDelay:4.0];
//                            i = 0; // 将计数器清0
//                            [self GetUserSyncData];
////                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] GetUserSyncData];
//                        }
//                        if (code == 400) {
//                            MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
//                            notice.mode = MBProgressHUDModeText;
//                            notice.labelText = json[@"message"];
//                            notice.yOffset = -40;
//                            [notice hide:YES afterDelay:4.0];
//                        }
//                    }
//                }];
                [SMNetWork sendRequestWithOperationManager:self.manager method:@"put" pathComponentsArr:@[@"/v2/shop/redeem/",[tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    int code = [responseObject[@"code"] intValue];
                    if (code == 200) {
                        
                        MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
                        notice.mode = MBProgressHUDModeText;
                        notice.labelText = responseObject[@"message"];
                        notice.yOffset = -40;
                        [notice hide:YES afterDelay:4.0];
                        i = 0; // 将计数器清0
                        [self GetUserSyncData];
                        //                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] GetUserSyncData];
                    }
                    if (code == 400) {
                        MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
                        notice.mode = MBProgressHUDModeText;
                        notice.labelText = responseObject[@"message"];
                        notice.yOffset = -40;
                        [notice hide:YES afterDelay:4.0];
                    }

                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }else {
            }
        }

    }
}
#pragma mark - 用户中心
- (IBAction)userPageButtonClick:(id)sender {
    if ([TokenManager getGuest]) {
        //游客
        [self guestAlertView];
    }else {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UserPageViewController * VC = [[UserPageViewController alloc] init];
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        
        [tempAppDelegate.mainNavigationController pushViewController:VC animated:NO];

    }
}


#pragma mark - 消息中心
- (IBAction)messageWebViewButtonClick:(id)sender {
    
    if ([TokenManager getGuest]) {
        //游客
        [self guestAlertView];
    }else {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CourseDetailsWebViewController * VC = [[CourseDetailsWebViewController alloc] init];
        VC.titleStr = NSLocalizedString(@"LEFT_MENU_MESSAGE", nil);
        VC.urlStr = [NSString stringWithFormat:@"%@?access_token=%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/messages"],[TokenManager getToken]];
        
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        
        [tempAppDelegate.mainNavigationController pushViewController:VC animated:NO];
    }

    
}


#pragma mark - 设置
- (IBAction)SettingsButtonClick:(id)sender {
//    SettingsViewController
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SettingsViewController * VC = [[SettingsViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    [tempAppDelegate.mainNavigationController pushViewController:VC animated:NO];

}



#pragma mark - 套餐
- (IBAction)VIPButtonClick:(id)sender {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    VIPShopViewController * VC = [[VIPShopViewController alloc] init];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    [tempAppDelegate.mainNavigationController pushViewController:VC animated:NO];

}

#pragma mark - 点击蒙版上的头像
-(void)event:(UITapGestureRecognizer *)gesture {
    [_bagBtn removeFromSuperview];
    [self userPageButtonClick:nil];
}

-(void)bagBtnClick:(UIButton *)sender {
    [_bagBtn removeFromSuperview];
}



#pragma mark - 点击优惠码
-(void)promotionalCodeClick {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SYSTEM_SETTINGS_PROMOTIONAL_CODE_ALERTVIEW_TITLE", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
    alertView.tag = 500;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * tf = [alertView textFieldAtIndex:0];
    tf.borderStyle = UITextBorderStyleNone;
    tf.placeholder = NSLocalizedString(@"SYSTEM_SETTINGS_PROMOTIONAL_CODE_ALERTVIEW_TITLE", nil);
    [alertView show];
}

#pragma mark -
#pragma mark - 输入优惠码后的逻辑
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
        [TokenManager saveUserdataWithDictionary:responseObject];
        [self.tableView reloadData];
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
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    if (self.watchProgress == 100) { // 获得徽章
        if (![self.goToUrl isEqualToString:@""]) {
            [self.dialog removeFromSuperview];
            self.view.userInteractionEnabled = YES;
            self.navigationController.view.userInteractionEnabled = YES;
            CourseDetailsWebViewController *cDWVC = [[CourseDetailsWebViewController alloc] init];
            cDWVC.titleStr = self.badge.gotoUrlTitle;
            cDWVC.urlStr = self.badge.gotoUrl;
            [delegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            [delegate.mainNavigationController pushViewController:cDWVC animated:YES];
        }else {
            [self dialogCloseBtnDidClick:button];
        }
    } else { // 去大师主页
        [self.dialog removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        self.navigationController.view.userInteractionEnabled = YES;
        YGMasterMainViewController *mMVC = [[YGMasterMainViewController alloc] init];
        mMVC.teacherID = [NSString stringWithFormat:@"%d", self.badge.teacherID];
        [delegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        [delegate.mainNavigationController pushViewController:mMVC animated:YES];
    }
}
#pragma mark - 登录按钮
- (IBAction)loginBtnClick:(id)sender {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginViewController * VC = [LoginViewController sharedLoginController];
    VC.loginSucc = ^ {
        [tempAppDelegate gotoHomeViewController];
    };
    SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
    LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    tempAppDelegate.window.rootViewController = LoginNav;
    [self presentViewController:LoginNav animated:YES completion:nil];
}
#pragma mark - 注册按钮
- (IBAction)registerBtnClick:(id)sender {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RegisterViewController * VC = [[RegisterViewController alloc] init];
    SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
    LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    tempAppDelegate.window.rootViewController = LoginNav;
    [self presentViewController:LoginNav animated:YES completion:nil];
}

- (void)dealloc
{
    SMLog(@"---侧边菜单栏-----挂了---------");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
