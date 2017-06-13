//
//  YGMasterMainViewController.m
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "YGMasterMainViewController.h"
#import "YGVideoCell.h"
#import "AFNetworking.h"
#import "YGTeacherCourse.h"
#import "YGCourseList.h"
#import "YGFlowLayout.h"
#import "TokenManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "VIPShopViewController.h"
#import "ShowMuseURLString.h"
#import "MBProgressHUD.h"
#import "PiwikTracker.h"
#import "SMHeaderView.h"
#import "Masonry.h"
#import "SMLessonDetailController.h"

#import "UserBadgesModel.h"
#import "UIImageView+WebCache.h"
#import "BadgeView.h"
#import "SMDialog.h"
#import "CourseDetailsWebViewController.h"

/**
 *  cell的重用标识
 */
static NSString * const VideoCellReuseIdentifier = @"VideoCell";

@interface YGMasterMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate,SMDialogDelegate> {
    UIView * bagview;
}

/** 保存所有视频的模型 */
@property (strong, nonatomic) NSMutableArray *videoListArr;
/** 保存老师的详情 */
@property (strong, nonatomic) YGTeacherCourse *teacher;
/** 头部控件 */
//@property (weak, nonatomic) UITableView *headView;
/** collectionView */
@property (weak, nonatomic) UICollectionView *collectionView;
/** 发网络请求的manager */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
/** HeaderView */
@property (weak, nonatomic) SMHeaderView *headerView;

/**
 *  徽章模型
 */
@property (strong, nonatomic) UserBadgesModel *badges;
/** 弹框控件 */
@property (weak, nonatomic) SMDialog *dialog;
/** 吸附动画 */
@property (strong, nonatomic) UIDynamicAnimator *anim;

@end

@implementation YGMasterMainViewController
- (UIDynamicAnimator *)anim
{
    if (!_anim) {
        _anim = [[UIDynamicAnimator alloc] init];
    }
    return _anim;
}

#pragma mark - lazy
- (NSMutableArray *)videoListArr
{
    if (!_videoListArr) {
        _videoListArr = [NSMutableArray array];
    }
    return _videoListArr;
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PiwikTracker sharedInstance] sendViews:@"teachers",_teacherID, nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // add loading
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 右边按钮
    [self setupNavRightBtn];
    // 发送网络请求
    [self sendRequest];
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData) name:SMVIPShopPurchaseSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeButtonClick) name:@"TeacherBadgeClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTeacherNotification:) name:@"likeTeacher" object:nil];
    
}
#pragma mark - 发送网路请求
- (void)reloadRequestData
{
    [self.videoListArr removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",[ShowMuseURLString URLStringWithPath:@"/v2/teachers"],self.teacherID];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [self.manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self transferDictTomodelWithResponseObject:responseObject];
        [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [ShowMuseURLString errorWithPerform:error];
        [SMNavigationController modalGlobalLoginViewController];
    }];
}

- (void)sendRequest
{
    [self.videoListArr removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",[ShowMuseURLString URLStringWithPath:@"/v2/teachers"],self.teacherID];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [self.manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.teacher = [YGTeacherCourse courseWithDict:responseObject];
        NSArray * badgeArr = responseObject[@"badges"];
        if (badgeArr.count > 0) {
            self.badges = [[UserBadgesModel alloc] initWithDictionary:badgeArr[0]];
        }
        
        // setup Navigation info
        [self setupNav];
        // create headerView
        [self setupHeadView];
        // create collectionView
        [self setupVideoListView];
        [self transferDictTomodelWithResponseObject:responseObject];
        // 刷新表格
        [self.collectionView reloadData];
        // cancel loading view cover
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ShowMuseURLString errorWithPerform:error];
        [SMNavigationController modalGlobalLoginViewController];
    }];
}
/**
 *  lessons字典数组转为模型数组
 */
- (void)transferDictTomodelWithResponseObject:(id)responseObject
{
    // 将lessons字典数组转为模型数组
    for (NSDictionary *dict in responseObject[@"lessons"]) {
        YGCourseList *course = [YGCourseList listWithDict:dict];
        [self.videoListArr addObject:course];
    }
}

#pragma mark - 添加界面一些子控件
- (void)setupNavRightBtn
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 18);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_course_home.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(teacherHomeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

/**
 *  设置导航栏部分
 */
- (void)setupNav
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = self.teacher.name;
    titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}

/**
 *  设置老师详细信息
 */
- (void)setupHeadView
{
    SMHeaderView *headerView = [[SMHeaderView alloc] init];
    headerView.teacher = self.teacher;
    headerView.badges = self.badges;
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(self.teacher.viewHeight > 112 ? self.teacher.viewHeight : 112);
    }];
}

/**
 *  设置底部视频collectionView
 */
- (void)setupVideoListView
{
    // 创建布局
    YGFlowLayout *layout = [[YGFlowLayout alloc] init];
    // 创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.contentSize = CGSizeMake(0, 1000);
    collectionView.contentInset = UIEdgeInsetsMake(10, 18, 10, 18);
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    // layout collectionView
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
    }];
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YGVideoCell class]) bundle:nil] forCellWithReuseIdentifier:VideoCellReuseIdentifier];
}

#pragma mark - UICollectionViewDataSource方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YGVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCellReuseIdentifier forIndexPath:indexPath];
    cell.course = self.videoListArr[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegate方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString * messageLogin = [userDefaults objectForKey:@"40301"];
    NSString * messageVIP = [userDefaults objectForKey:@"40302"];

    YGCourseList *course = self.videoListArr[indexPath.row];
    if (!course.isLockedToUser) {
        SMLessonDetailController *lessonVC = [[SMLessonDetailController alloc] init];
        lessonVC.lessonID = [NSString stringWithFormat:@"%ld",course.ID];
        [self.navigationController pushViewController:lessonVC animated:YES];
        
    }else {
        if (![TokenManager getGuest]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:messageVIP delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 200;
            [alertView show];
        }else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:messageLogin delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 100;
            [alertView show];
            
        }
    }
    
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
            VIPShopViewController * VC = [[VIPShopViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];

        }
    }
}

#pragma mark - 接收通知的方法
-(void)likeTeacherNotification:(NSNotification *)dict {
//    NSInteger teacherID = [dict.userInfo[@"teacherID"] integerValue];
    if ([dict.userInfo[@"isFavourite"] boolValue]) {
        [self delLikeTeacherNetWorkWithTeacherID:dict.userInfo[@"teacherID"]];
    }else {
        [self likeTeacherNetWorkWithTeacherID:dict.userInfo[@"teacherID"]];
    }
}
#pragma mark - 关注大师
-(void)likeTeacherNetWorkWithTeacherID:(NSString *)teacherID {
    NSString * path = [NSString stringWithFormat:@"/v2/teachers/%@/favourites",teacherID];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"put" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 取消关注
-(void)delLikeTeacherNetWorkWithTeacherID:(NSString *)teacherID {
    NSString * path = [NSString stringWithFormat:@"/v2/teachers/%@/favourites",teacherID];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"delete" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - 徽章点击通知方法
-(void)badgeButtonClick {
    bagview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bagview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    bagview.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [bagview addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    [[UIApplication sharedApplication].delegate.window addSubview:bagview];
    
    
//    UserBadgesModel *badgesModel = badgesArray[sender.tag];
    UIImageView *imgview = [[UIImageView alloc] init];
    [imgview sd_setImageWithURL:[NSURL URLWithString:self.badges.img]];
    
    
    SMDialog *dialog = [[SMDialog alloc] initWithImage:imgview.image contentText:self.badges.progressDescription delegate:self leftButtonTitle:self.badges.progressPopupBtnTitle rightButtonTitle:nil];
//    dialog.leftButton.tag = sender.tag;
    BadgeView *halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    float angle = self.badges.progress/100.00;
    [halfChart addAngleValue:angle andColor:[UIColor clearColor]];
    [halfChart addAngleValue:(1-angle) andColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [halfChart resignFirstResponder];
    [dialog.badgeView addSubview:halfChart];
    
    if (self.badges.progress == 100) {
        [dialog.leftButton setBackgroundColor:colorWithRGB(65, 198, 228)];
    }else {
        [dialog.leftButton setBackgroundColor:colorWithRGB(225, 96, 75)];
    }
    
    [[UIApplication sharedApplication].delegate.window addSubview:dialog];
    UISnapBehavior *snapB = [[UISnapBehavior alloc] initWithItem:dialog snapToPoint:CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.39)];
    snapB.damping = 0.4;
    [self.anim addBehavior:snapB];
    self.dialog = dialog;
}
-(void)event:(UITapGestureRecognizer *)gesture {
    [bagview removeFromSuperview];
    [self.dialog removeFromSuperview];
}
#pragma mark - SMDialogDelegate
- (void)dialogCloseBtnDidClick:(UIButton *)button
{
    [bagview removeFromSuperview];
    [self.dialog removeFromSuperview];
}
- (void)dialogLeftButtonDidClick:(UIButton *)button {
    
    
//    UserBadgesModel *badgesModel = badgesArray[button.tag];
    
    SMLog(@"-- gotoUrl -- > %@ -- progress -- > %d ", self.badges.gotoUrl, self.badges.progress);
    if (self.badges.teacherID != 0) {
        if (self.badges.progress == 100) {
            if (![self.badges.gotoUrl isEqualToString:@""]) {
                //跳转web
                self.navigationController.navigationBar.alpha = 1;
                CourseDetailsWebViewController *VC = [[CourseDetailsWebViewController alloc] init];
                VC.titleStr = self.badges.gotoUrlTitle;
                VC.urlStr = self.badges.gotoUrl;
                [self.navigationController pushViewController:VC animated:YES];
            }
        }else {
            //跳转课程
//            self.navigationController.navigationBar.alpha = 1;
//            YGMasterMainViewController *VC = [[YGMasterMainViewController alloc] init];
//            VC.teacherID = [NSString stringWithFormat:@"%d",badgesModel.teacherID];
//            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    
    [bagview removeFromSuperview];
    [self.dialog removeFromSuperview];
}




#pragma mark - 导航按钮
- (void)teacherHomeBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
