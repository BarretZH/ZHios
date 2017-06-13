//
//  CategoriesViewController.m
//  ShowMuse
//
//  Created by show zh on 16/6/20.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "CategoriesViewController.h"
#import "MJRefresh.h"
#import "MyQuestionTableViewCell.h"
#import "MyQusetionModel.h"
#import "JCTagView.h"
//#import "CategroriesNetWork.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"

#import "TokenManager.h"
#import "SMLessonDetailController.h"
#import "CourseViewController.h"

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "VIPShopViewController.h"

#import "MBProgressHUD.h"
#import "PiwikTracker.h"
#import "SearchViewController.h"
#import "BadgeView.h"

@interface CategoriesViewController ()<UITableViewDelegate,UITableViewDataSource,RelatedCoursesDelegate,UIAlertViewDelegate> {
    float relatedHeight;
}

@property (strong, nonatomic) UITableView * tableView;

@property (nonatomic) int offset;

@property (strong, nonatomic) NSMutableArray * modelArray;

@property (strong, nonatomic) BadgeView * halfChart;
@property (strong, nonatomic) UIImageView *progressImageView;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation CategoriesViewController
- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * categoryID = [NSString stringWithFormat:@"%d",_ID];
    [[PiwikTracker sharedInstance] sendViews:@"category",categoryID, nil];
    [self addNavigationItem];
    self.modelArray = [[NSMutableArray alloc] initWithCapacity:0];
    _offset = 0;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SMScreenWidth, SMScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadMoreData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData:) name:SMVIPShopPurchaseSuccessNotification object:nil];
}
#pragma mark - 设置导航
-(void)addNavigationItem {
    UILabel *titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = self.titleStr;
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

}
#pragma mark - 通知方法
- (void)reloadRequestData:(NSNotification *)note {
    [self.modelArray removeAllObjects];
    _offset = 0;
    [self loadMoreData];
}
#pragma mark - 上拉加载
-(void)loadMoreData {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [CategroriesNetWork categoriesLessonWithID:[NSString stringWithFormat:@"%d",self.ID] offset:[NSString stringWithFormat:@"%d",_offset] Complete:^(id json, NSError *error) {
////        SMLog(@"--------%@-------%@",error,json);
//        if (error == nil) {
//            if ([json[@"lessons"] count] == 0) {
//                [_tableView.mj_footer endRefreshingWithNoMoreData];
//                
//            }else {
//                [json[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    MyQusetionModel * model = [[MyQusetionModel alloc] initWithDictionary:obj];
//                    [self.modelArray addObject:model];
//                }];
//                [self.tableView reloadData];
//                
//                [_tableView.mj_footer endRefreshing];
//                _offset = _offset + 10;
//                self.tableView.mj_footer.hidden = (0 == self.modelArray.count) ? YES : NO;
//            }
//        }else {
//            [SMNavigationController modalGlobalLoginViewController];
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
    NSString * path = [NSString stringWithFormat:@"/v2/categories/%d/lessons",self.ID];
    NSDictionary* requestParameters = @{@"limit":@"10",@"offset":[NSString stringWithFormat:@"%d",_offset]};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[path] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"lessons"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else {
            [responseObject[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MyQusetionModel * model = [[MyQusetionModel alloc] initWithDictionary:obj];
                [self.modelArray addObject:model];
            }];
            [self.tableView reloadData];
            
            [_tableView.mj_footer endRefreshing];
            _offset = _offset + 10;
            self.tableView.mj_footer.hidden = (0 == self.modelArray.count) ? YES : NO;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * str = @"cell";
    MyQuestionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    MyQusetionModel * model = self.modelArray[indexPath.row];
    cell.model = model;
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyQuestionTableViewCell" owner:nil options:nil]objectAtIndex:0];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (model.isNew) {
        cell.isNewImage.alpha = 1;
    }else {
        cell.isNewImage.alpha = 0;
    }
    CGRect rect = [model.title boundingRectWithSize:CGSizeMake(SMScreenWidth-192-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    NSString *titString = model.title;
//    SMLog(@"高度-----%f",rect.size.height);
    if (rect.size.height > 65) {
        titString =[model.title substringToIndex:35];
    }
    cell.titleLabel.text = titString;

//    cell.titleLabel.text = model.title;
    [cell.viewsTotalButton setTitle:[NumberStr numberOfstring:model.viewsTotal] forState:UIControlStateNormal];
    if (![model.thumb isEqual:[NSNull null]]) {
        [cell.lessonButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal];
    }
    cell.lessonButton.tag = indexPath.row;
    [cell.lessonButton addTarget:self action:@selector(lessonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (model.isLockedToUser) {
        
        cell.isLockedToUserImage.image = [UIImage imageNamed:@"icon_course_lock.png"];
    }else {
        
        cell.isLockedToUserImage.image = [UIImage imageNamed:@"icon_course_play.png"];
    }
//    SMLog(@"**************%lu",(unsigned long)[cell.titleLabel.text length]);
    cell.timeLabel.text = model.videoDurationTime;
    relatedHeight = 0;
    UIView * view = (UIView *)[cell viewWithTag:50000];
    [view removeFromSuperview];
    if (model.relatedCoursesArray.count > 0) {
        JCTagView *JCView = [[JCTagView alloc] initWithFrame:CGRectMake(5, 121, [UIScreen mainScreen].bounds.size.width-10, 0)];
        JCView.tag = 50000;
        JCView.JCSignalTagColor = [UIColor colorWithRed:215/255.0 green:237/255.0 blue:243/255.0 alpha:1];
        JCView.JCbackgroundColor = [UIColor clearColor];
        [JCView setArrayTagWithLabelArray:model.relatedCoursesArray];
        JCView.delegate = self;
        relatedHeight = JCView.bounds.size.height;
        //        JCView.backgroundColor = [UIColor redColor];
        [cell addSubview:JCView];
    }
    
    cell.progressLabel.text = [NSString stringWithFormat:@"%d%%",model.watchProgress];
    float angle = model.watchProgress/100.00;
    [_halfChart removeAllSubviews];
    [_progressImageView removeAllSubviews];
    _halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    //    _halfChart.transform = CGAffineTransformMakeRotation(M_PI_2);
    [cell.progressView addSubview:_halfChart];
    [_halfChart addAngleValue:angle andColor:colorWithRGBA(83, 211, 230, 1)];
    [_halfChart addAngleValue:(1-angle) andColor:colorWithRGBA(233, 232, 235, 1)];
    
    _progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 12, 12)];
    _progressImageView.image = [UIImage imageNamed:@"course"];
    [cell.progressView addSubview:_progressImageView];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return relatedHeight+121;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyQusetionModel * model = self.modelArray[indexPath.row];
    [self isLockedToUser:model];
}

#pragma mark - 点击图片按钮的方法
-(void)lessonButtonClick:(UIButton *)sender {
    MyQusetionModel *model = self.modelArray[sender.tag];
    //    [self gotoLessonDetails:model.ID];
    [self isLockedToUser:model];
}


#pragma mark - 标签的代理方法
-(void)relatedCoursesWithID:(NSString *)ID
{
    self.navigationController.navigationBar.alpha = 1;
    CourseViewController * VC = [[CourseViewController alloc] init];
    VC.ID = ID;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 判断是否可以打开视频详情
-(void)isLockedToUser:(MyQusetionModel *)model {
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString * messageLogin = [userDefaults objectForKey:@"40301"];
    NSString * messageVIP = [userDefaults objectForKey:@"40302"];
    //    ZHLessonModel * lessons = _lessonGroup.lessonsArray[sender.tag];
    
    if (model.isLockedToUser) {
        //不可以看
        
        if (![TokenManager getGuest]) {
            
            //购买Vip
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:messageVIP delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 200;
            [alertView show];
        }else {
            //登录
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:messageLogin delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 100;
            [alertView show];
        }
        
    }else {
        //可以看
        [self gotoLessonDetails:model.ID];
    }
    
}

#pragma mark - 进入课程详情
-(void)gotoLessonDetails:(NSInteger)ID
{
    self.navigationController.navigationBar.alpha = 1;
    SMLessonDetailController *lDVC = [[SMLessonDetailController alloc] init];
    lDVC.lessonID = [NSString stringWithFormat:@"%zd", ID];
    [self.navigationController pushViewController:lDVC animated:YES];
    
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
            
            self.navigationController.navigationBar.alpha = 1;
            VIPShopViewController * VC = [[VIPShopViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    }
}

#pragma mark - 导航返回按钮
-(void)liftButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -搜索按钮
-(void)rightButtonClick
{
    SearchViewController *VC = [[SearchViewController alloc] init];
    VC.categoriesID = self.ID;
    [self.navigationController pushViewController:VC animated:YES];
    
}


@end
