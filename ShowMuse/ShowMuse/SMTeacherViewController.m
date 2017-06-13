//
//  SMTeacherViewController.m
//  ShowMuse
//
//  Created by show zh on 16/11/14.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "SMTeacherViewController.h"
#import "SMHome_TeacherTableViewCell.h"
#import "SMNetWork.h"
#import "AFNetworking.h"
#import "UIButton+WebCache.h"
#import "YGMasterMainViewController.h"
#import "MJRefresh.h"
//#import "Teachers.h"

@interface SMTeacherViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
    int offset;
    NSString * sontBy;
}
@property (weak, nonatomic) IBOutlet UITableView *teacherTableView;

@property (strong, nonatomic)NSMutableArray * teacherArray;

@property (strong, nonatomic)NSMutableArray * likeArray;

@property (strong,nonatomic)UIScrollView *topScrollView;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation SMTeacherViewController

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
- (NSMutableArray *)teacherArray
{
    if (!_teacherArray) {
        _teacherArray = [NSMutableArray array];
    }
    return _teacherArray;
}
-(NSMutableArray *)likeArray
{
    if (!_likeArray) {
        _likeArray = [NSMutableArray array];
    }
    return _likeArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.teacherArray = [[NSMutableArray alloc] initWithCapacity:0];
//    NSArray * likeArray = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
//    float widht = 50;
    offset = 0;
    sontBy =@"crtAt";
    self.tbLabel.text = NSLocalizedString(@"MAIN_TEACHER_GURU_LIST", nil);
    [self.maxViewsBtn setTitle:NSLocalizedString(@"MAIN_TEACHER_TOP_BTN", nil) forState:UIControlStateNormal];
    [self.crtAtBtn setTitle:NSLocalizedString(@"MAIN_TEACHER_NEW_BTN", nil) forState:UIControlStateNormal];
    [self getTeacherDataNetWork];
    [self getLikeTeacherDataNetWork];
//    self.teacherTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTeacherNotification:) name:@"likeTeacher" object:nil];
}

#pragma mark - 请求列表数据
-(void)getTeacherDataNetWork {
    offset = 0;
    NSString * offsetStr = [NSString stringWithFormat:@"%d",offset];
    NSDictionary * paramtersDic = @{@"limit":@"10",@"offset":offsetStr,@"sortBy":sontBy};//crtAt 时间  maxViews按人气
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/teachers"] parameters:paramtersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.teacherArray removeAllObjects];
        [responseObject[@"teachers"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Teachers * teacher = [[Teachers alloc] initWithDictionary:obj];
            [self.teacherArray addObject:teacher];
        }];
        [self.teacherTableView reloadData];
        self.teacherTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
#pragma mark - 上拉加载
-(void)loadMoreData {
    offset = offset+10;
    NSString * offsetStr = [NSString stringWithFormat:@"%d",offset];
    NSDictionary * paramtersDic = @{@"limit":@"10",@"offset":offsetStr,@"sortBy":sontBy};//crtAt 时间  maxViews按人气
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/teachers"] parameters:paramtersDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SMLog(@"-------**------%@",responseObject);
        if ([responseObject[@"teachers"] count] == 0) {
            [self.teacherTableView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [responseObject[@"teachers"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Teachers * teacher = [[Teachers alloc] initWithDictionary:obj];
                [self.teacherArray addObject:teacher];
            }];
            [self.teacherTableView reloadData];
            [self.teacherTableView.mj_footer endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 请求关注的数据
-(void)getLikeTeacherDataNetWork {
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/teachers/favourites"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SMLog(@"/*/*/*/*/%@",responseObject);
        [self.likeArray removeAllObjects];
        [responseObject[@"teachers"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Teachers * teacher = [[Teachers alloc] initWithDictionary:obj];
            [self.likeArray addObject:teacher];
        }];
        self.topLikeLabel.text = responseObject[@"blockTitle"];
        [self.topScrollView removeFromSuperview];
        [self addScrollViewSubviewWithArray:self.likeArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - 滑动视图的布局
-(void)addScrollViewSubviewWithArray:(NSArray *)likeArray {
    float widht = 50;
    if (likeArray.count > 0) {
        
        self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 28, SMScreenWidth, 90)];
        self.topScrollView.delegate = self;
        self.topScrollView.pagingEnabled = YES;
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        self.topScrollView.contentSize = CGSizeMake(50*likeArray.count+(likeArray.count-1)*26+20, 90);
        [self.view addSubview:self.topScrollView];

        
        for (int i = 0; i<likeArray.count; i++) {
            Teachers * teacher = likeArray[i];
            UIButton * headImgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            headImgBtn.frame = CGRectMake(10+(widht+26)*i, 10, widht, widht);
            [headImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:teacher.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head.png"]];
            headImgBtn.tag = [teacher.ID intValue];
            headImgBtn.layer.cornerRadius = 25;
            headImgBtn.clipsToBounds = YES;
            [headImgBtn addTarget:self action:@selector(scrollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.topScrollView addSubview:headImgBtn];
            
            UILabel * topNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(widht+26)*i, 10+widht, widht, 34)];
            topNameLabel.text = teacher.name;
            topNameLabel.font = [UIFont systemFontOfSize:13.0f];
            topNameLabel.numberOfLines = 0;
            topNameLabel.textAlignment = NSTextAlignmentCenter;
            [self.topScrollView addSubview:topNameLabel];

        }
    }
}




//-(void)setTeacherTableViewArray:(NSMutableArray *)teacherTableViewArray {
////    self.teacherTableViewArray = teacherTableViewArray;
//    SMLog(@"/*/*/*/*/*/*%lu",(unsigned long)self.teacherTableViewArray.count);
//}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teacherArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * str = @"teacher_cell0";
    SMHome_TeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SMHome_TeacherTableViewCell" owner:nil options:nil]objectAtIndex:0];
    }
    Teachers * teacher = self.teacherArray[indexPath.row];
    cell.teacher = teacher;
    cell.teacher_isFavouriteImg.tag = indexPath.row;
    [cell.teacher_isFavouriteImg addTarget:self action:@selector(likeTeacher:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([sontBy isEqualToString:@"maxViews"]) {
        if (indexPath.row == 0) {
            cell.teacher_topImg.alpha = 1;
            cell.teacher_topLabel.alpha = 1;
            cell.teacher_topImg.image = [UIImage imageNamed:@"icon_first.png"];
            cell.teacher_topLabel.text = NSLocalizedString(@"MAIN_TEACHER_NO1", nil);
        }else if (indexPath.row == 1) {
            cell.teacher_topImg.alpha = 1;
            cell.teacher_topLabel.alpha = 1;
            cell.teacher_topImg.image = [UIImage imageNamed:@"icon_second.png"];
            cell.teacher_topLabel.text = NSLocalizedString(@"MAIN_TEACHER_NO2", nil);
        }else if (indexPath.row == 2) {
            cell.teacher_topImg.alpha = 1;
            cell.teacher_topLabel.alpha = 1;
            cell.teacher_topImg.image = [UIImage imageNamed:@"icon_third.png"];
            cell.teacher_topLabel.text = NSLocalizedString(@"MAIN_TEACHER_NO3", nil);
        }else {
            cell.teacher_topImg.alpha = 0;
            cell.teacher_topLabel.alpha = 0;
        }
    }else {
        cell.teacher_topImg.alpha = 0;
        cell.teacher_topLabel.alpha = 0;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Teachers * teacher = self.teacherArray[indexPath.row];
    YGMasterMainViewController * teacherVC = [[YGMasterMainViewController alloc] init];
    teacherVC.teacherID = teacher.ID;
    [self.navigationController pushViewController:teacherVC animated:YES];
}
#pragma mark - scrollView上面的按钮点击
-(void)scrollBtnClick:(UIButton *)sender {
    YGMasterMainViewController * teacherVC = [[YGMasterMainViewController alloc] init];
    teacherVC.teacherID = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self.navigationController pushViewController:teacherVC animated:YES];
}


#pragma mark - 人气和最新的切换方法
- (IBAction)sontByBtnClick:(id)sender {
    UIButton * senderBtn = (UIButton *)sender;
    if (senderBtn.tag == 100) {
        //按人气
        if ([sontBy isEqualToString:@"maxViews"]) {
            //不作处理
        }else {
            sontBy = @"maxViews";
            [self.maxViewsBtn setBackgroundImage:[UIImage imageNamed:@"icon_left_on.png"] forState:UIControlStateNormal];
            [self.crtAtBtn setBackgroundImage:[UIImage imageNamed:@"icon_right_off.png"] forState:UIControlStateNormal];
            [self getTeacherDataNetWork];
            [self.teacherTableView setContentOffset:CGPointMake(0,0)animated:NO];
        }
    }
    if (senderBtn.tag == 200) {
        //按最新
        if ([sontBy isEqualToString:@"crtAt"]) {
            //不作处理
        }else {
            sontBy = @"crtAt";
            [self.maxViewsBtn setBackgroundImage:[UIImage imageNamed:@"icon_left_off.png"] forState:UIControlStateNormal];
            [self.crtAtBtn setBackgroundImage:[UIImage imageNamed:@"icon_right_on.png"] forState:UIControlStateNormal];
            [self getTeacherDataNetWork];
            [self.teacherTableView setContentOffset:CGPointMake(0,0)animated:NO];
        }
    }
}
#pragma mark - 列表上面的关注按钮
-(void)likeTeacher:(UIButton *)sender {
    SMLog(@"*---------*");
    Teachers * teacher = self.teacherArray[sender.tag];
    if (teacher.isFavourite) {
        //取消关注
        [sender setBackgroundImage:[UIImage imageNamed:@"heart_no.png"] forState:UIControlStateNormal];
        teacher.isFavourite = NO;
        [self delLikeTeacherNetWorkWithTeacherID:teacher.ID];
    }else {
        [sender setBackgroundImage:[UIImage imageNamed:@"heart_.png"] forState:UIControlStateNormal];
        teacher.isFavourite = YES;
        [self likeTeacherNetWorkWithTeacherID:teacher.ID];
    }
}

#pragma mark - 接收通知的方法
-(void)likeTeacherNotification:(NSNotification *)dict {
    NSInteger teacherID = [dict.userInfo[@"teacherID"] integerValue];
    if ([dict.userInfo[@"isFavourite"] boolValue]) {
        [self delLikeTeacherNetWorkWithTeacherID:dict.userInfo[@"teacherID"]];
    }else {
        [self likeTeacherNetWorkWithTeacherID:dict.userInfo[@"teacherID"]];
    }
    for (int i=0; i<self.teacherArray.count; i++) {
        Teachers * teacher = self.teacherArray[i];
        if (teacherID == [teacher.ID integerValue]) {
            teacher.isFavourite = !teacher.isFavourite;
            [self.teacherTableView reloadData];
            return;
        }
    }
    
}
#pragma mark - 关注大师
-(void)likeTeacherNetWorkWithTeacherID:(NSString *)teacherID {
    NSString * path = [NSString stringWithFormat:@"/v2/teachers/%@/favourites",teacherID];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"put" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SMLog(@"------>>>guanzhu<<<%@",responseObject);
        [self.likeArray removeAllObjects];
        [responseObject[@"teachers"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Teachers * teacher = [[Teachers alloc] initWithDictionary:obj];
            [self.likeArray addObject:teacher];
        }];
        self.topLikeLabel.text = responseObject[@"blockTitle"];
        [self.topScrollView removeFromSuperview];
        [self addScrollViewSubviewWithArray:self.likeArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 取消关注
-(void)delLikeTeacherNetWorkWithTeacherID:(NSString *)teacherID {
    NSString * path = [NSString stringWithFormat:@"/v2/teachers/%@/favourites",teacherID];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"delete" pathComponentsArr:@[path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SMLog(@"------>>>quxiao<<<%@",responseObject);
        [self.likeArray removeAllObjects];
        [responseObject[@"teachers"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Teachers * teacher = [[Teachers alloc] initWithDictionary:obj];
            [self.likeArray addObject:teacher];
        }];
        self.topLikeLabel.text = responseObject[@"blockTitle"];
        [self.topScrollView removeFromSuperview];
        [self addScrollViewSubviewWithArray:self.likeArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SMLog(@"dashisile123456");
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
