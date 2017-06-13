//
//  MyQuestionViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "MyQuestionViewController.h"

#import "MyQuestionTableViewCell.h"

#import "MJRefresh.h"

//#import "UserNetWork.h"
#import "AFNetworking.h"

#import "MyQusetionModel.h"

#import "UIButton+WebCache.h"

#import "JCTagView.h"

#import "CourseViewController.h"

#import "TokenManager.h"

#import "AppDelegate.h"

#import "LoginViewController.h"

#import "VIPShopViewController.h"

#import "MBProgressHUD.h"

#import "BadgeView.h"
#import "SMLessonDetailController.h"

@interface MyQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,RelatedCoursesDelegate,UIAlertViewDelegate> {
    UITableView * _tableView;
    int offset;
    NSMutableArray * lessonArray;
    float relatedHeight;
    
    int fist;
    

}
@property (strong, nonatomic) BadgeView * halfChart;
@property (strong, nonatomic) UIImageView *progressImageView;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation MyQuestionViewController
- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
//    NSLog(@"**********%f",_tableView.frame.size.height);
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.rowHeight = 162;
//    [self.view addSubview:_tableView];

    fist = 0;
    offset = 0;
    lessonArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [self loadMoreData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData:) name:SMVIPShopPurchaseSuccessNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (fist == 0) {
        self.view.backgroundColor = [UIColor clearColor];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height-20) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 162;
        [self.view addSubview:_tableView];
        
        if (lessonArray.count > 0) {
            [lessonArray removeAllObjects];
        }
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _tableView.mj_footer.hidden = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadMoreData];

    }
    fist++;
}

#pragma mark - 通知方法
- (void)reloadRequestData:(NSNotification *)note {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //1.删除数组
    [lessonArray removeAllObjects];
    //2.发请求
    offset = 0;
    NSString * offsetStr = [NSString stringWithFormat:@"%d",offset];
//    [UserNetWork CouesesDetailsWithOffset:offsetStr Complete:^(id json, NSError *error) {
//        if (error == nil) {
//            if ([json[@"userLessons"] count] == 0) {
//                [_tableView.mj_footer endRefreshingWithNoMoreData];
//            }else {
//                [json[@"userLessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    MyQusetionModel * model = [[MyQusetionModel alloc] initWithDictionary:obj];
//                    [lessonArray addObject:model];
//                    //                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//                }];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [_tableView reloadData];
//                [_tableView.mj_footer endRefreshing];
//                offset = offset + 10;
//            }
//        }else {
//            [SMNavigationController modalGlobalLoginViewController];
//        }
//    }];
    
    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offsetStr};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/user/lessons"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"userLessons"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [responseObject[@"userLessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MyQusetionModel * model = [[MyQusetionModel alloc] initWithDictionary:obj];
                [lessonArray addObject:model];
            }];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            offset = offset + 10;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 上拉加载
-(void)loadMoreData {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * offsetStr = [NSString stringWithFormat:@"%d",offset];
    //    self.tableView.mj_footer.hidden = NO;
//    [UserNetWork CouesesDetailsWithOffset:offsetStr Complete:^(id json, NSError *error) {
////        SMLog(@"---------->>>>%@-------%@",error,json);
//        if (error == nil) {
//            if ([json[@"userLessons"] count] == 0) {
//                [_tableView.mj_footer endRefreshingWithNoMoreData];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            }else {
//                [json[@"userLessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    MyQusetionModel * model = [[MyQusetionModel alloc] initWithDictionary:obj];
//                    [lessonArray addObject:model];
////                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//                }];
//                [_tableView reloadData];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [_tableView.mj_footer endRefreshing];
//                offset = offset + 10;
//                _tableView.mj_footer.hidden = (4 > lessonArray.count) ? YES : NO;
//            }
//        }else {
//            [SMNavigationController modalGlobalLoginViewController];
//        }
//        
//    }];
    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offsetStr};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/user/lessons"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"userLessons"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }else {
            [responseObject[@"userLessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MyQusetionModel * model = [[MyQusetionModel alloc] initWithDictionary:obj];
                [lessonArray addObject:model];
                //                    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            }];
            [_tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_tableView.mj_footer endRefreshing];
            offset = offset + 10;
            _tableView.mj_footer.hidden = (4 > lessonArray.count) ? YES : NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return lessonArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * str = @"cell";
    MyQuestionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyQuestionTableViewCell" owner:nil options:nil]objectAtIndex:0];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyQusetionModel * model = lessonArray[indexPath.row];
    cell.model = model;
    CGRect rect = [model.title boundingRectWithSize:CGSizeMake(SMScreenWidth-192-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    NSString *titString = model.title;
    if (rect.size.height > 65) {
        titString =[model.title substringToIndex:35];
    }
    cell.titleLabel.text = titString;
    [cell.viewsTotalButton setTitle:[NumberStr numberOfstring:model.viewsTotal] forState:UIControlStateNormal];
    if (![model.thumb isEqual:[NSNull null]]) {
        [cell.lessonButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal];
    }
    if (model.isNew) {
        cell.isNewImage.alpha = 1;
    }else {
        cell.isNewImage.alpha = 0;
    }
    cell.lessonButton.tag = indexPath.row;
    [cell.lessonButton addTarget:self action:@selector(lessonButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    if (model.isLockedToUser) {

        cell.isLockedToUserImage.image = [UIImage imageNamed:@"icon_course_lock.png"];
    }else {

        cell.isLockedToUserImage.image = [UIImage imageNamed:@"icon_course_play.png"];
    }

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
    MyQusetionModel * model = lessonArray[indexPath.row];
    [self isLockedToUser:model];
}

#pragma mark - 点击图片按钮的方法
-(void)lessonButtonClick:(UIButton *)sender
{
    MyQusetionModel *model = lessonArray[sender.tag];
    [self isLockedToUser:model];
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
-(void)gotoLessonDetails:(NSInteger)ID {
    self.navigationController.navigationBar.alpha = 1;
    SMLessonDetailController *lDVC = [[SMLessonDetailController alloc] init];
    lDVC.lessonID = [NSString stringWithFormat:@"%zd", ID];
    [self.navigationController pushViewController:lDVC animated:YES];

}

#pragma mark - 标签的代理方法
-(void)relatedCoursesWithID:(NSString *)ID {
    self.navigationController.navigationBar.alpha = 1;
    CourseViewController * VC = [[CourseViewController alloc] init];
    VC.ID = ID;
    [self.navigationController pushViewController:VC animated:YES];
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

#pragma mark - 计算高度
-(CGFloat)creatBubbleCGrectWithString:(NSString *)string
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return ceilf(rect.size.height);
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
