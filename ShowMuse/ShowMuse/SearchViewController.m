//
//  SearchViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchTableViewCell.h"

#import "SeacherNetWork.h"
#import "AFNetworking.h"

#import "SearchModel.h"

#import "MJRefresh.h"

#import "UIButton+WebCache.h"

#import "UIImageView+WebCache.h"

#import "SMLessonDetailController.h"

#import "TokenManager.h"

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "VIPShopViewController.h"

#import "MBProgressHUD.h"

#import "PiwikTracker.h"

#import "SearchTeacherModel.h"

#import "YGMasterMainViewController.h"

#import "BadgeView.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
    NSMutableArray * lessonsArray;
    int offsetInt;
    NSString * seacherStr;
    BOOL isfirst;
}
@property (strong, nonatomic) BadgeView * halfChart;
@property (strong, nonatomic) UIImageView *progressImageView;


@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation SearchViewController
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
    if (_isTeacher) {
        SMLog(@"-----搜索大师-----");
    }else {
        SMLog(@"-----搜索课程-----");
    }
    SMLog(@"---->>>%d",self.categoriesID);
    
    self.txtLabel.text = NSLocalizedString(@"NO_SEARCH_RESULT", nil);
    
    [[PiwikTracker sharedInstance] sendViews:@"lessons_search", nil];
    
    self.searchTextField.placeholder = NSLocalizedString(@"SEARCH", nil);
    [self.cancelButton setTitle:NSLocalizedString(@"SEARCH_CANCEL", nil) forState:UIControlStateNormal];
    
    
    isfirst = YES;
    offsetInt = 0;
    seacherStr = @"";
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    lessonsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData:) name:SMVIPShopPurchaseSuccessNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];

    self.navigationController.navigationBar.alpha = 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return lessonsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isTeacher) {
        static NSString * str = @"cell_teacher";
        SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:nil options:nil]objectAtIndex:1];
        }
        SearchTeacherModel * teacherModel = lessonsArray[indexPath.row];
        [cell.teacherImage sd_setImageWithURL:[NSURL URLWithString:teacherModel.avatar] placeholderImage:[UIImage imageNamed:@"head"]];
        cell.teacherNameLabel.text = teacherModel.name;
        return cell;
    }else {
        static NSString * str = @"cell";
        SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
        SearchModel * searchModel = lessonsArray[indexPath.row];
        if (searchModel.isNew) {
            cell.isNewImage.alpha = 1;
        }else {
            cell.isNewImage.alpha = 0;
        }
        cell.titleLabel.text = searchModel.title;
        cell.videoTimeLabel.text = searchModel.videoDurationTime;
        [cell.viewsTotalButton setTitle:[NumberStr numberOfstring:searchModel.viewsTotal] forState:UIControlStateNormal];
        if (searchModel.isLockedToUser) {
            cell.isLockedToUserImage.image = [UIImage imageNamed:@"icon_course_lock.png"];
        }else {
            cell.isLockedToUserImage.image = [UIImage imageNamed:@"icon_course_play.png"];
        }
        [cell.thumbButton sd_setBackgroundImageWithURL:[NSURL URLWithString:searchModel.thumb] forState:UIControlStateNormal placeholderImage:nil];
        cell.thumbButton.tag = indexPath.row;
        [cell.thumbButton addTarget:self action:@selector(thumbButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.progressLabel.text = [NSString stringWithFormat:@"%d%%",searchModel.watchProgress];
        float angle = searchModel.watchProgress/100.00;
        [_halfChart removeAllSubviews];
        [_progressImageView removeAllSubviews];
        _halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
        //    _halfChart.transform = CGAffineTransformMakeRotation(M_PI_2);
        [cell.progressView addSubview:_halfChart];
        [_halfChart addAngleValue:angle andColor:colorWithRGBA(83, 211, 230, 1)];
        [_halfChart addAngleValue:(1-angle) andColor:colorWithRGBA(233, 232, 235, 1)];
        
        _progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 11, 11)];
        _progressImageView.image = [UIImage imageNamed:@"course"];
        [cell.progressView addSubview:_progressImageView];

        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isTeacher) {
        return 60;
    }else {
        return 124;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_isTeacher) {
        //大师
        self.navigationController.navigationBar.alpha = 1;
        SearchTeacherModel * teacherModel = lessonsArray[indexPath.row];
        YGMasterMainViewController * VC = [[YGMasterMainViewController alloc] init];
//        VC.isSearch = YES;
        VC.teacherID = [NSString stringWithFormat:@"%d",teacherModel.ID];
        [self.navigationController pushViewController:VC animated:YES];
    }else {
        SearchModel * searchModel = lessonsArray[indexPath.row];
        [self isLockedToUser:searchModel];
    }
}




#pragma mark - 点击视频图片的方法
-(void)thumbButtonClick:(UIButton *)sender {
    SearchModel * searchModel = lessonsArray[sender.tag];
    [self isLockedToUser:searchModel];
}

#pragma mark - 判断是否可以打开视频详情
-(void)isLockedToUser:(SearchModel *)model {
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
        [self gotoLessonDetailsWithID:model.ID];
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
//            NSLog(@"购买VIP");
            VIPShopViewController *vip = [[VIPShopViewController alloc] init];
            [self.navigationController pushViewController:vip animated:YES];
        }
    }
}

#pragma mark - 跳转课文详情
-(void)gotoLessonDetailsWithID:(NSInteger)ID
{
    self.navigationController.navigationBar.alpha = 1;
    SMLessonDetailController *lDVC = [[SMLessonDetailController alloc] init];
    lDVC.lessonID = [NSString stringWithFormat:@"%zd", ID];
    [self.navigationController pushViewController:lDVC animated:YES];
}


#pragma mark - 课文上拉加载
-(void)loadMoreData {
    offsetInt = offsetInt+10;
    NSString * offsetStr = [NSString stringWithFormat:@"%d",offsetInt];
    if (![seacherStr isEqualToString:@""]) {
        [self httpSearchLesson:seacherStr offset:offsetStr];
    }
    
}
#pragma mark - 分类上拉加载
-(void)categoriesLoadMoreData {
    offsetInt = offsetInt+10;
    NSString * offsetStr = [NSString stringWithFormat:@"%d",offsetInt];
    NSString * ID = [NSString stringWithFormat:@"%d",self.categoriesID];
    if (![seacherStr isEqualToString:@""]) {
//        [self httpSearchLesson:seacherStr offset:offsetStr];
        [self httpCategoriesSearch:seacherStr categoriesID:ID offset:offsetStr];
    }
}

#pragma mark - UITextFieldDelegate键盘发送按钮的方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    seacherStr = [textField.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [lessonsArray removeAllObjects];
    [_tableView reloadData];
    if (![textField.text isEqualToString:@""]) {
        if (_isTeacher) {
            //大师
            [self httpTeacherSearch:seacherStr];
        }else {
            if (self.categoriesID == 0) {
                //课文搜索
                [self httpSearchLesson:seacherStr offset:@"0"];
            }else {
                //分类搜索
                NSString * ID = [NSString stringWithFormat:@"%d",self.categoriesID];
                [self httpCategoriesSearch:seacherStr categoriesID:ID offset:@"0"];
            }
            
        }
        self.tableView.mj_footer.hidden = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    return NO;
}

#pragma mark - 返回按钮
- (IBAction)gotoBack:(id)sender {
    self.navigationController.navigationBar.alpha = 1;
        [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 通知方法
- (void)reloadRequestData:(NSNotification *)note {
    //1.加遮盖
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //2.删数组
    [lessonsArray removeAllObjects];
    offsetInt = 0;
    //3.发请求
    if (self.categoriesID == 0) {
//        [SeacherNetWork searchLessonWithOffset:@"0" search:seacherStr Complete:^(id json, NSError *error) {
//            if (error == nil) {
//                [json[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
//                    [lessonsArray addObject:searchModel];
//                }];
//                [self.tableView reloadData];
//                // 取消遮盖
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }];
        NSDictionary * requestParameters = @{@"limit":@"10",@"offset":@"0",@"search":seacherStr};
        [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [responseObject[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
                [lessonsArray addObject:searchModel];
            }];
            [self.tableView reloadData];
            // 取消遮盖
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SMNavigationController modalGlobalLoginViewController];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }else {
        NSString * ID = [NSString stringWithFormat:@"%d",self.categoriesID];
//        [SeacherNetWork categoriesSearchLessonWithOffset:@"0" search:seacherStr category:ID Complete:^(id json, NSError *error) {
//            if (json) {
//                [json[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
//                    [lessonsArray addObject:searchModel];
//                }];
//                [self.tableView reloadData];
//                self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        }];
        NSDictionary * requestParameters = @{@"limit":@"10",@"offset":@"0",@"search":seacherStr,@"category":ID};
        [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [responseObject[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
                [lessonsArray addObject:searchModel];
            }];
            [self.tableView reloadData];
            self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SMNavigationController modalGlobalLoginViewController];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
}

#pragma mark - 发请求
-(void)httpSearchLesson:(NSString *)search offset:(NSString *)offset {
    //加入遮盖
//    [SeacherNetWork searchLessonWithOffset:offset search:search Complete:^(id json, NSError *error) {
//        NSArray * jsonArray = json[@"lessons"];
//        if (error == nil) {
//            [json[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
//                [lessonsArray addObject:searchModel];
//            }];
//            
//            if (jsonArray.count > 0) {
//                self.tableView.alpha = 1;
//                [_tableView reloadData];
//                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//            }else {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                if (lessonsArray.count == 0) {
//                    self.tableView.alpha = 0;
//                }
//            }
//            self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
//            
//            // 取消遮盖
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//        }else {
//            [SMNavigationController modalGlobalLoginViewController];
//        }
//        
//    }];
    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offset,@"search":search};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * jsonArray = responseObject[@"lessons"];
        [responseObject[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
            [lessonsArray addObject:searchModel];
        }];
        
        if (jsonArray.count > 0) {
            self.tableView.alpha = 1;
            [_tableView reloadData];
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (lessonsArray.count == 0) {
                self.tableView.alpha = 0;
            }
        }
        self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
        
        // 取消遮盖
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - 发请求-大师
-(void)httpTeacherSearch:(NSString *)search {
//    [SeacherNetWork teacherSearchNSString:search Complete:^(id json, NSError *error) {
//        if (error == nil) {
//            [json[@"teachers"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                SearchTeacherModel * teacher = [[SearchTeacherModel alloc] initWithDictionary:obj];
//                [lessonsArray addObject:teacher];
//            }];
//            NSArray * jsonArray = json[@"teachers"];
//            if (jsonArray.count > 0) {
//                self.tableView.alpha = 1;
//                [_tableView reloadData];
//            }else {
//                if (lessonsArray.count == 0) {
//                    self.tableView.alpha = 0;
//                }
//            }
//            self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        }
//    }];
    NSDictionary * requestParameters = @{@"search":search};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/teachers"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [responseObject[@"teachers"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchTeacherModel * teacher = [[SearchTeacherModel alloc] initWithDictionary:obj];
            [lessonsArray addObject:teacher];
        }];
        NSArray * jsonArray = responseObject[@"teachers"];
        if (jsonArray.count > 0) {
            self.tableView.alpha = 1;
            [_tableView reloadData];
        }else {
            if (lessonsArray.count == 0) {
                self.tableView.alpha = 0;
            }
        }
        self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 分类请求
- (void)httpCategoriesSearch:(NSString *)search categoriesID:(NSString *)ID offset:(NSString *)offset {
//    [SeacherNetWork categoriesSearchLessonWithOffset:offset search:search category:ID Complete:^(id json, NSError *error) {
//        if (json) {
//            NSArray * jsonArray = json[@"lessons"];
//            [json[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
//                [lessonsArray addObject:searchModel];
//            }];
//            if (jsonArray.count > 0) {
//                self.tableView.alpha = 1;
//                [_tableView reloadData];
//                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(categoriesLoadMoreData)];
//            }else {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                if (lessonsArray.count == 0) {
//                    self.tableView.alpha = 0;
//                }
//            }
//            self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
//        }else {
//            [SMNavigationController modalGlobalLoginViewController];
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offset,@"search":search,@"category":ID};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * jsonArray = responseObject[@"lessons"];
        [responseObject[@"lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SearchModel * searchModel = [[SearchModel alloc] initWithDictionary:obj];
            [lessonsArray addObject:searchModel];
        }];
        if (jsonArray.count > 0) {
            self.tableView.alpha = 1;
            [_tableView reloadData];
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(categoriesLoadMoreData)];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (lessonsArray.count == 0) {
                self.tableView.alpha = 0;
            }
        }
        self.tableView.mj_footer.hidden = (0 == lessonsArray.count) ? YES : NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - 清除按钮
- (IBAction)deleteTextFieldButton:(id)sender {
    self.searchTextField.text = @"";
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
