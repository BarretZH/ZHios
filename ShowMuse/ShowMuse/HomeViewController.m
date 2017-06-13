//
//  HomeViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/3.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
//#import "WJItemsControlView.h"
//#import "HomeNetWork.h"
#import "Teachers.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "QuestionTableViewCell.h"
#import "MJRefresh.h"
#import "Courses.h"
#import "TokenManager.h"
#import "CourseViewController.h"
//#import "MainNetWorking.h"
#import "JPUSHService.h"
#import "LeftSortsViewController.h"
#import "LoginViewController.h"
#import "YGMasterMainViewController.h"
#import "SearchViewController.h"
#import "SMLessonGroup.h"
#import "Banners.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UserBadgesModel.h"
#import "SMDialog.h"
#import "SDWebImageDownloader.h"
#import "PopupModel.h"
#import "CourseDetailsWebViewController.h"
#import "ShowMuseURLString.h"
#import "PiwikTracker.h"
#import "SMDownloadController.h"

#import "SMTeacherViewController.h"




#import "UserPageViewController.h"
#import "CoursesDetailsViewController.h"
#import "VIPShopViewController.h"
#import "CategoriesModel.h"
#import "ZFPlayer.h"

static NSString * const SMCourseCellIdentifier = @"HomeQuestion";

@interface HomeViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, SMDialogDelegate>
{
//    WJItemsControlView *_itemControlView;
    NSMutableArray * teachersArray;
    int offset;
    NSMutableArray * questionArray;
    
    NSMutableArray * bannersArray;
    UIImageView * imgView;
    
//    NSInteger bannerNumber;
    
    BOOL isTeacher;
    
    BOOL isCourses;

    NSInteger clickTeacher;
    
    BOOL isSearchTeacher;
    
    int time;
    NSTimer * timer;
}
/** tableView */
@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *questionBtn;

@property (weak, nonatomic) IBOutlet UIButton *teacherBtn;

@property (weak, nonatomic) IBOutlet UIView *courseView;

@property (weak, nonatomic) IBOutlet UIView *teacherView;

/** dialog */
@property (weak, nonatomic) SMDialog *dialog;
/** 保存所有课程的模型 */
@property (strong, nonatomic) NSMutableArray *courseArr;
/** 保存所有网络获取到的徽章 */
@property (strong, nonatomic) NSMutableArray *popupArr;
/** 保存所有创建的对话框 */
@property (strong, nonatomic) NSMutableArray *dialogArr;
/** 发网络请求的manager */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
/** 弹框动画 */
@property (strong, nonatomic) UIDynamicAnimator *anim;
/** 记录badge的观看进度 */
@property (assign, nonatomic) NSInteger watchProgress;
/** 记录goToUrl */
@property (copy, nonatomic) NSString *goToUrl;
/** badge模型 */
@property (strong, nonatomic) UserBadgesModel *badge;

@property (strong, nonatomic) UIImageView * messImage;
/**
 *  保存关注按钮
 */
@property (strong, nonatomic) NSMutableArray *likeBtnArray;


@property (strong, nonatomic) UIImageView * imgViews;


@property (strong, nonatomic) NSData * teacherData;

@property (strong, nonatomic) UIButton * bannerCloseBtn;

@end

@implementation HomeViewController
#pragma mark - lazy
- (NSMutableArray *)courseArr
{
    if (!_courseArr) {
        _courseArr = [NSMutableArray array];
    }
    return _courseArr;
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}

- (NSMutableArray *)popupArr
{
    if (!_popupArr) {
        _popupArr = [NSMutableArray array];
    }
    return _popupArr;
}

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

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
//    SMLog(@"%f----------%f",SMScreenWidth,SMScreenHeight);
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"user_email"];
    [userDefaults synchronize];
    isSearchTeacher = NO;
    teachersArray = [[NSMutableArray alloc] initWithCapacity:0];
    //加入遮盖
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view endEditing:YES];
    // 添加tableView
    [self questionUIShow];
    // 添加头尾刷新控件
    [self setupRefreshWedgets];
    
//    bannerNumber = 0;

    if ([TokenManager getGuest]) {
        //游客
       
    }else {
       
//        [PiwikTracker sharedInstance].userID = 
    }
#if TARGET_VERSION_LITE ==1
//    NSLog(@"aaaaaaaaaaaaaaaa");
#elif TARGET_VERSION_LITE ==2
//    NSLog(@"bbbbbbbbbbbbbbbbbbbbbb");
#endif
    isTeacher = YES;
    isCourses = YES;
    // 设置课程 - 大师 按钮
    self.questionBtn.titleLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:14];
    self.teacherBtn.titleLabel.font = [UIFont fontWithName:@"HiraginoSansGB-W6" size:14];
    [self.questionBtn setTitle:NSLocalizedString(@"MAIN_PAGE_NEW_QUESTION", nil) forState:UIControlStateNormal];
    [self.teacherBtn setTitle:NSLocalizedString(@"MAIN_PAGE_MASTER", nil) forState:UIControlStateNormal];
    
    // 导航栏标题 HiraginoSansGB-W3
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"HiraginoSansGB-W6" size:30]};
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:30]};
    UILabel * titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = NSLocalizedString(@"MAIN_PAGE_MY_QUESTION", nil);
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;
    
    
    UIImageView *navBarHairlineImageView;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    _messImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, -5, 10, 10)];
    _messImage.image = [UIImage imageNamed:@"icon_reddot"];
    NSInteger number = [userDefaults integerForKey:@"messagesTotal"];
    if (number > 0) {
        _messImage.alpha = 1;
    }else {
        _messImage.alpha = 0;
    }
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
//    if ([TokenManager getGuest]) {
//        //游客
//        NSLog(@"/*/*游客登录");
//        [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_password.png"] forState:UIControlStateNormal];
//    }else {
//        NSLog(@"账号登录");
        [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
//    }

    [menuBtn addSubview:_messImage];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    bannersArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self bannersView];
//    [self userData];
//    NSArray *languages = [NSLocale preferredLanguages];
//    NSString *currentLanguage = [languages objectAtIndex:0];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTeacher:) name:@"likeTeacher" object:nil];
    [self getCategories];
}
///**
// *  user sync
// */
//- (void)GetUserSyncData
//{/*
//    SMLog(@"执行了-------");
//    NSString *urlStr = [ShowMuseURLString URLStringWithPath:@"/v2/user/sync"];
//    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
//    [self.manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"deviceId"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    params[@"badge"] = @(1);
//    params[@"popup"] = @(1);
//    [self.manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // 徽章
//        i = 0;
//        [self.dialogArr removeAllObjects];
//        NSDictionary *badgeDict = [responseObject[@"badges"] firstObject];
//        if (badgeDict) {
//            UserBadgesModel *badge = [[UserBadgesModel alloc] initWithDictionary:badgeDict];
//            self.badge = badge;
//            NSURL *url = [NSURL URLWithString:badge.img];
//            UIImageView *imageView = [[UIImageView alloc] init];
//            [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (badge.progress == 100) {
//                    [self addBadgeDialogWithModel:badge image:imageView.image colorWithR:65 g:198 b:228];
//                } else {
//                    [self addBadgeDialogWithModel:badge image:imageView.image colorWithR:225 g:96 b:75];
//                }
//                
//                // popup消息
//                [self addPopupDialogWithData:responseObject];
//            }];
//        } else {
//            
//            [self addPopupDialogWithData:responseObject];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       
//    }];
//    */
//}

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
//    [self.dialogArr removeAllObjects];
}

#pragma mark - 导航关于
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

/**
 *  问题界面tableView
 */
#pragma mark - 问题界面
-(void)questionUIShow
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-53-64) style:UITableViewStylePlain];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.courseView addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = SMScreenWidth*160/375;
    self.tableView = tableView;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QuestionTableViewCell class]) bundle:nil] forCellReuseIdentifier:SMCourseCellIdentifier];
    
}

#pragma mark - 头尾刷新控件的一些方法
// 增加头尾刷新控件
-(void)setupRefreshWedgets
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewPhoto)];
    // 一进来就刷新
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePhoto)];
    self.tableView.mj_footer.hidden = YES;
    
}
// 刷新获得新数据
-(void)loadNewPhoto
{
    [self.tableView.mj_footer endRefreshing];
    offset = 0;
    [self.courseArr removeAllObjects];
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offset];
    
    NSDictionary* requestParameters = @{@"limit":@"10",@"offset":offsetStr,@"withGroups":@"1"};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/courses"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self transferDictionaryToModelWithJSON:responseObject];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        // 取消遮盖
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self checkFooterStatus];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SMNavigationController modalGlobalLoginViewController];
        [self.tableView.mj_header endRefreshing];
    }];
}
// 上拉加载获得更多数据
-(void)loadMorePhoto
{
    [self.tableView.mj_header endRefreshing];
    offset += 10;
    NSString * offsetStr = [NSString stringWithFormat:@"%d",offset];
//    [HomeNetWork questionNetWorkWithOffset:offsetStr Complete:^(id json, NSError *error) {
//        if (json == nil) {
//            [SMNavigationController modalGlobalLoginViewController];
//            [self.tableView.mj_footer endRefreshing];
//        }else {
//            [self transferDictionaryToModelWithJSON:json];
//            // 结束刷新
//            [self.tableView.mj_footer endRefreshing];
//            [self.tableView reloadData];
//            
//            if ([json[@"courses"] count] == 0) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
//    }];
    NSDictionary* requestParameters = @{@"limit":@"10",@"offset":offsetStr,@"withGroups":@"1"};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/courses"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self transferDictionaryToModelWithJSON:responseObject];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if ([responseObject[@"courses"] count] == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [self.tableView.mj_footer endRefreshing];
    }];
}
// 字典转为模型
- (void)transferDictionaryToModelWithJSON:(id)json
{
    for (NSDictionary *courseDict in json[@"courses"]) {
        
        Courses *course = [Courses courseWithDict:courseDict];
        
        for (NSDictionary *lessonGroup in courseDict[@"lessonGroups"]) {
            SMLessonGroup *group = [SMLessonGroup groupWithDict:lessonGroup];
            [course.lessonGroups addObject:group];
        }
        [self.courseArr addObject:course];
    }
}
#pragma mark - 是否隐藏上拉加载控件
- (void)checkFooterStatus
{
    self.tableView.mj_footer.hidden = (0 == self.courseArr.count) ? YES : NO;
}
#pragma mark - 用户数据获取
-(void)userData {
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    NSString * jpushID = [JPUSHService registrationID];//获取极光的registrationID
    if (jpushID == nil) {
        jpushID = @"";
    }else {
    }
    NSDictionary* requestParameters = @{@"deviceId":identifierStr,@"jpushId":jpushID};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/sync"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [TokenManager saveUserdataWithDictionary:responseObject];
        NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
        NSInteger number = [userDefaults integerForKey:@"messagesTotal"];
        if (number > 0) {
            _messImage.alpha = 1;
        }else {
            _messImage.alpha = 0;
        }
        
        if ([TokenManager getGuest]) {
            //游客
        }else {
            [PiwikTracker sharedInstance].userID = [NSString stringWithFormat:@"%ld",(long)[userDefaults integerForKey:@"user_ID"]];
        }
        if ([PiwikTracker sharedInstance].userID) {
        }else {
            [PiwikTracker sharedInstance].userID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        
        if (isCourses) {
            [[PiwikTracker sharedInstance] sendViews:@"courses", nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark - 大师界面
-(void)teachersUIshowArray:(NSMutableArray *)array
{
    [self.teacherView removeAllSubviews];
    SMTeacherViewController * teacherVC = [[SMTeacherViewController alloc] init];
    teacherVC.view.frame = CGRectMake(0, 0, self.teacherView.frame.size.width, self.teacherView.frame.size.height);
    [self.teacherView addSubview:teacherVC.view];
    [self addChildViewController:teacherVC];
    [teacherVC didMoveToParentViewController:self];

    
}
#pragma mark - 关注按钮的点击方法
//-(void)likeButtonClick:(UIButton *)sender {
//    for (int i = 0; i<teachersArray.count; i++) {
//        Teachers *teacherModel = teachersArray[i];
//        if (sender.tag == [teacherModel.ID integerValue]) {
//            NSString * path = [NSString stringWithFormat:@"/v2/teachers/%@/favourites",teacherModel.ID];
//            if (teacherModel.isFavourite) {
//                //取消关注
//                [sender setBackgroundImage:[UIImage imageNamed:@"heart_no"] forState:UIControlStateNormal];
////                [HomeNetWork favouritesTeacherWithisPUT:NO teacherID:teacherModel.ID Complete:^(id json, NSError *error) {
////                }];
//                [SMNetWork sendRequestWithOperationManager:self.manager method:@"DELETE" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
//            }else {
//                //关注
//                [sender setBackgroundImage:[UIImage imageNamed:@"heart_"] forState:UIControlStateNormal];
////                [HomeNetWork favouritesTeacherWithisPUT:YES teacherID:teacherModel.ID Complete:^(id json, NSError *error) {
////                }];
//                SMLog(@"%@",teacherModel.ID);
//                [SMNetWork sendRequestWithOperationManager:self.manager method:@"PUT" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
//            }
//            teacherModel.isFavourite = !teacherModel.isFavourite;
//            SMLog(@"--------状态--------%d",teacherModel.isFavourite);
//            _itemControlView.teacherArray = teachersArray;
//            [_itemControlView likeImageViewChangeWithTag:sender.tag];
//
//        }
//    }
//    
//}
#pragma mark - 关注按钮接收的通知方法
//-(void)likeTeacher:(NSNotification *)dict {
//    
//    clickTeacher = [dict.userInfo[@"teacherID"] integerValue];
//    for (int i = 0; i<teachersArray.count; i++) {
//        Teachers *teacherModel = teachersArray[i];
//        if (clickTeacher == [teacherModel.ID integerValue]) {
//            UIButton * sender = _likeBtnArray[i];
//            NSString * path = [NSString stringWithFormat:@"/v2/teachers/%@/favourites",teacherModel.ID];
//            if (teacherModel.isFavourite) {
//                [sender setBackgroundImage:[UIImage imageNamed:@"heart_no"] forState:UIControlStateNormal];
//                [SMNetWork sendRequestWithOperationManager:self.manager method:@"DELETE" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
//            }else {
//                [sender setBackgroundImage:[UIImage imageNamed:@"heart_"] forState:UIControlStateNormal];
//                [SMNetWork sendRequestWithOperationManager:self.manager method:@"PUT" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    
//                }];
//            }
//            teacherModel.isFavourite = !teacherModel.isFavourite;
////            SMLog(@"--------状态--------%d",teacherModel.isFavourite);
//            _itemControlView.teacherArray = teachersArray;
//            [_itemControlView likeImageViewChangeWithTag:clickTeacher];
//
//        }
//    }
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.courseArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SMCourseCellIdentifier];
    if (self.courseArr.count > 0) {
        cell.course = self.courseArr[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.courseArr.count == 0) return;
    Courses *course= self.courseArr[indexPath.row];
    CourseViewController *coursesVC = [[CourseViewController alloc] init];
    coursesVC.ID = course.ID;
    [self.navigationController pushViewController:coursesVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 问题/大师按钮
- (IBAction)questionAndTeacherBtnClick:(UIButton *)sender {
//    [sender setTintColor:[UIColor colorWithRed:89/255.0 green:212/255.0 blue:234/255.0 alpha:1]];
    [sender setTitleColor:[UIColor colorWithRed:89/255.0 green:212/255.0 blue:234/255.0 alpha:1] forState:UIControlStateNormal];
    if (sender.tag == 100) {
        [[PiwikTracker sharedInstance] sendViews:@"courses", nil];
        //点击问题
        [_teacherBtn setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1] forState:UIControlStateNormal];
        _courseView.alpha = 1;
        _teacherView.alpha = 0;
        isSearchTeacher = NO;
    }
    if (sender.tag == 200) {
        isSearchTeacher = YES;
        [[PiwikTracker sharedInstance] sendViews:@"teachers", nil];
        //点击大师
        [self teachersUIshowArray:teachersArray];
        
        [_questionBtn setTitleColor:[UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1] forState:UIControlStateNormal];
        _courseView.alpha = 0;
        _teacherView.alpha = 1;
        isTeacher = NO;
    }
}
#pragma mark - 大师详情
//-(void)teacherDetails:(UIButton *)button {
////    clickTeacher = button.tag+500;
//    Teachers * teacher = teachersArray[button.tag];
//    YGMasterMainViewController * teacherVC = [[YGMasterMainViewController alloc] init];
//    teacherVC.teacherID = teacher.ID;
//    clickTeacher = [teacher.ID integerValue];
//    [self.navigationController pushViewController:teacherVC animated:YES];
//}



//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    float offset = scrollView.contentOffset.x;
//    offset = offset/CGRectGetWidth(scrollView.frame);
////    [_itemControlView moveToIndex:offset];
//
//    
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    float offset = scrollView.contentOffset.x;
//    offset = offset/CGRectGetWidth(scrollView.frame);
////    [_itemControlView endMoveToIndex:offset];
//
//}


#pragma mark - 搜索按钮
-(void)rightButtonClick {
    SearchViewController * VC = [[SearchViewController alloc] init];
    VC.isTeacher = isSearchTeacher;
    [self.navigationController pushViewController:VC animated:YES];
    
}


#pragma mark - 侧滑
- (void)openOrCloseLeftList
{
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"click" action:@"leftmenu" name:@"event_leftmenu" value:@(2)];
    
//    [self userData];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"userData" object:nil userInfo:nil];
    
    
//    if (![TokenManager getGuest]) {
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (tempAppDelegate.LeftSlideVC.closed)
        {
            [tempAppDelegate.LeftSlideVC openLeftView];
        }
        else
        {
            [tempAppDelegate.LeftSlideVC closeLeftView];
        }
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self userData];
//    [self GetUserSyncData];
    [tempAppDelegate GetUserSyncData];
    self.navigationController.navigationBar.alpha = 1;
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
    self.navigationController.navigationBarHidden = NO;
//    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}



#pragma mark - 获取banner图
-(void)bannersView {
//    [HomeNetWork fullScreenBannersComplete:^(id json, NSError *error) {
//        if (error == nil) {
//            [json[@"banners"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                Banners * bannerModel = [[Banners alloc] initWithDictionary:obj];
//                [bannersArray addObject:bannerModel];
//            }];
//            [self showBanners];
//        }
//    }];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/ads/full-screen-banners"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [responseObject[@"banners"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Banners * bannerModel = [[Banners alloc] initWithDictionary:obj];
            [bannersArray addObject:bannerModel];
        }];
        if (bannersArray.count>0) {
            [self showBanners];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
#pragma mark - 显示banner图
-(void)showBanners {
    
//    bannerNumber = 60000;
//    for (NSInteger i = bannersArray.count; i>0; i--) {
        Banners * bannerModel = bannersArray[0];
        _imgViews = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _imgViews.tag = 60000;
//        [_imgViews sd_setImageWithURL:[NSURL URLWithString:bannerModel.url]];
        _imgViews.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
        [_imgViews addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTapsRequired:1];
        
//        [[UIApplication sharedApplication].delegate.window addSubview:_imgViews];
    
        self.bannerCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bannerCloseBtn.frame = CGRectMake(SMScreenWidth-80, 20, 70, 30);
        self.bannerCloseBtn.backgroundColor = colorWithRGBA(0, 0, 0, 0.3);
    [_imgViews sd_setImageWithURL:[NSURL URLWithString:bannerModel.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (bannerModel.showTimer == 0) {
            [self.bannerCloseBtn setTitle:NSLocalizedString(@"MAIN_CLOSE_BANNER", nil) forState:UIControlStateNormal];
        }else {
            [self.bannerCloseBtn setTitle:[NSString stringWithFormat:@"%ds %@",bannerModel.showTimer,NSLocalizedString(@"MAIN_CLOSE_BANNER", nil)] forState:UIControlStateNormal];
            NSDictionary * dic = @{@"time":[NSString stringWithFormat:@"%d",bannerModel.showTimer]};
            time = bannerModel.showTimer;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimeWithDic:) userInfo:dic repeats:YES];
        }
        [self.bannerCloseBtn setTintColor:colorWithRGBA(255, 255, 255, 0.8)];
        self.bannerCloseBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.bannerCloseBtn.layer.cornerRadius = 15.0;
        [self.bannerCloseBtn addTarget:self action:@selector(closeBannerImage) forControlEvents:UIControlEventTouchUpInside];
        [_imgViews addSubview:self.bannerCloseBtn];

    }];
//    if (bannerModel.showTimer == 0) {
//        [self.bannerCloseBtn setTitle:NSLocalizedString(@"MAIN_CLOSE_BANNER", nil) forState:UIControlStateNormal];
//    }else {
//        [self.bannerCloseBtn setTitle:[NSString stringWithFormat:@"%ds %@",bannerModel.showTimer,NSLocalizedString(@"MAIN_CLOSE_BANNER", nil)] forState:UIControlStateNormal];
//        NSDictionary * dic = @{@"time":[NSString stringWithFormat:@"%d",bannerModel.showTimer]};
//        time = bannerModel.showTimer;
//        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimeWithDic:) userInfo:dic repeats:YES];
//    }
//        [self.bannerCloseBtn setTintColor:colorWithRGBA(255, 255, 255, 0.8)];
//        self.bannerCloseBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//        self.bannerCloseBtn.layer.cornerRadius = 15.0;
//        [self.bannerCloseBtn addTarget:self action:@selector(closeBannerImage) forControlEvents:UIControlEventTouchUpInside];
//        [_imgViews addSubview:self.bannerCloseBtn];
        [[UIApplication sharedApplication].delegate.window addSubview:_imgViews];
//    }

    
}
#pragma mark - 定时器的方法
-(void)onTimeWithDic:(NSTimer *)dic {
//    SMLog(@"**************%@",dic.userInfo[@"time"]);
    
    if (time == 0) {
        [timer invalidate];
        timer = nil;
        [self closeBannerImage];
    }
    time--;
    [self.bannerCloseBtn setTitle:[NSString stringWithFormat:@"%ds %@",time,NSLocalizedString(@"MAIN_CLOSE_BANNER", nil)] forState:UIControlStateNormal];
}
#pragma mark - 点击banner图的方法
-(void)event:(UITapGestureRecognizer *)gesture {
    /*
//    Banners * bannerModel = bannersArray[bannerNumber-60000];
//    
//    [HomeNetWork postFullScreenBannersID:[NSString stringWithFormat:@"%d",bannerModel.ID] Complete:^(id json, NSError *error) {
////        NSLog(@"%@*********%@",json,error);
//    }];
//    [[[UIApplication sharedApplication].delegate.window viewWithTag:bannerNumber] removeFromSuperview];
//    bannerNumber = bannerNumber+1;
     */
//    [self closeBannerImage];
    Banners * bannerModel = bannersArray[/*bannerNumber-60000*/0];
    if ([bannerModel.link isEqualToString:@""]) {
        
        [self closeBannerImageNetWork];
        [self removeBanner];
    }else {
        [self closeBannerImageNetWork];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerModel.link]];
        [[ZFPlayerView sharedPlayerView] resetPlayer]; // 杀掉播放器
        for (int i = 0; i < bannersArray.count; i++) {
            [self removeBanner];
        }
    }
    [timer invalidate];
    timer = nil;
}
#pragma mark - 点击跳过按钮的方法
-(void)closeBannerImage {
    [self closeBannerImageNetWork];
    [timer invalidate];
    timer = nil;
    for (int i = 0; i < bannersArray.count; i++) {
        [self removeBanner];
    }
}
#pragma mark - 表示看过banner图，向后台发消息
-(void)closeBannerImageNetWork {
//    SMLog(@"点击的图片是----%ld",(long)bannerNumber);
    Banners * bannerModel = bannersArray[/*bannerNumber-60000*/0];
    
//    [HomeNetWork postFullScreenBannersID:[NSString stringWithFormat:@"%d",bannerModel.ID] Complete:^(id json, NSError *error) {
//    
//    }];
    NSString * bannerModelID = [NSString stringWithFormat:@"%d",bannerModel.ID];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/ads/full-screen-banners/", bannerModelID , @"/read"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 移除banner图
-(void)removeBanner {
    [[[UIApplication sharedApplication].delegate.window viewWithTag:60000] removeFromSuperview];
//    bannerNumber = bannerNumber+1;
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
    self.view.userInteractionEnabled = YES;
    self.navigationController.view.userInteractionEnabled = YES;
    if (self.watchProgress == 100) { // 获得徽章
        if (![self.goToUrl isEqualToString:@""]) {
            [self.dialog removeFromSuperview];
            CourseDetailsWebViewController *cDWVC = [[CourseDetailsWebViewController alloc] init];
            cDWVC.titleStr = self.badge.gotoUrlTitle;
            cDWVC.urlStr = self.badge.gotoUrl;
            [self.navigationController pushViewController:cDWVC animated:YES];
        }else {
            [self dialogCloseBtnDidClick:button];
        }
    } else { // 去大师主页
        [self.dialog removeFromSuperview];
        YGMasterMainViewController *mMVC = [[YGMasterMainViewController alloc] init];
        mMVC.teacherID = [NSString stringWithFormat:@"%d", self.badge.teacherID];
        [self.navigationController pushViewController:mMVC animated:YES];
    }
}



#pragma mark - 获取分类数据
-(void)getCategories {
    NSMutableArray * catArr = [[NSMutableArray alloc] initWithCapacity:0];
//    [HomeNetWork caregoriesComplete:^(id json, NSError *error) {
//        if (json) {
//            SMLog(@"-------保存分类信息-----");
//            [json enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                CategoriesModel * categories = [[CategoriesModel alloc] initWithDictionary:obj];
//                [catArr addObject:categories];
//            }];
//            NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//            NSString * path = [NSString stringWithFormat:@"%@/catarr.txt",pathDir];
//            NSMutableData *data = [[NSMutableData alloc]init];
//            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//            [archiver encodeRootObject:catArr];
//            [archiver finishEncoding];
//            [data writeToFile:path atomically:YES];
//            
//        }else {
//            [SMNavigationController modalGlobalLoginViewController];
//        }
//    }];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/categories"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SMLog(@"-------保存分类信息-----");
        [responseObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CategoriesModel * categories = [[CategoriesModel alloc] initWithDictionary:obj];
            [catArr addObject:categories];
        }];
        NSString *pathDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString * path = [NSString stringWithFormat:@"%@/catarr.txt",pathDir];
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeRootObject:catArr];
        [archiver finishEncoding];
        [data writeToFile:path atomically:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
    }];
}



- (void)dealloc
{
    SMLog(@"---主页-----挂了---------");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
