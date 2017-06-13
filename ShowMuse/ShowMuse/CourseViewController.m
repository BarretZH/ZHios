//
//  CourseViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/11.
//  Copyright © 2016年 show zh. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "CourseViewController.h"
#import "AppDelegate.h"
#import "CoursesTableViewCell.h"
#import "CoursesNetWork.h"
#import "SMCourseLessonGroup.h"
#import "SMCourseLesson.h"
#import "SMCourseTeacher.h"
#import "MBProgressHUD.h"
#import "CoursesDetailsViewController.h"
#import "Masonry.h"
#import "VIPShopViewController.h"
#import "SMTableViewController.h"

#import "PiwikTracker.h"

@interface CourseViewController ()<UIScrollViewDelegate, UIAlertViewDelegate>

/** scrollView */
@property (weak, nonatomic) UIScrollView *scrollView;
/** headerView控件 */
@property (weak, nonatomic) UIView *headerView;
/** 分割线 */
@property (weak, nonatomic) UIView *sepLine;
/** 记录当前选中的button */
@property (weak, nonatomic) UIButton *selectedBtn;
/** 保存所有课程的section */
@property (strong, nonatomic) NSMutableArray *lessonSectionArr;
/** 保存所有的课程包 */
@property (strong, nonatomic) NSMutableArray *lessonGroupArr;
/** 保存所有按钮 */
@property (strong, nonatomic) NSMutableArray *buttonsArr;
/** tableView */
@property (weak, nonatomic) UITableView *tableView;

@end


@implementation CourseViewController

#pragma mark - lazy
- (NSMutableArray *)lessonSectionArr
{
    if (!_lessonSectionArr) {
        _lessonSectionArr = [NSMutableArray array];
    }
    return _lessonSectionArr;
}

- (NSMutableArray *)lessonGroupArr
{
    if (!_lessonGroupArr) {
        _lessonGroupArr = [NSMutableArray array];
    }
    return _lessonGroupArr;
}

- (NSMutableArray *)buttonsArr
{
    if (!_buttonsArr) {
        _buttonsArr = [NSMutableArray array];
    }
    return _buttonsArr;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];

    [super viewDidLoad];
    // 发送网络请求
    [self sendRequest];
    // 设置标题
    [self setupTitleView];
    // 设置导航栏
//    [self setupNav];
    // 增加头部控件
    [self setupHeaderView];
    // 加入遮盖
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData:) name:SMVIPShopPurchaseSuccessNotification object:nil];
    
}
#pragma mark - 两个发送网络请求的方法
- (void)reloadRequestData:(NSNotification *)note
{
    // 1.删除数组
    [self.lessonSectionArr removeAllObjects];
    // 2.添加遮盖
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // 3.发送网络请求
    [CoursesNetWork CouesesDetailsWithID:self.ID Complete:^(id json, NSError *error) {
        if (json) {
            
            [self transferDictionaryToModelWithJSON:json];
            // 将数组传给tableView
            for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
                SMTableViewController *tbVC = (SMTableViewController *)self.childViewControllers[i];
                SMCourseLessonGroup *lessonGroup = self.lessonSectionArr[i];
                tbVC.lessonsArr = lessonGroup.lessonModelsArr;
                [tbVC.tableView reloadData];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    }];
}

// 发送网络请求
- (void)sendRequest
{
    [CoursesNetWork CouesesDetailsWithID:self.ID Complete:^(id json, NSError *error) {
        if (json) {
            // 字典转模型
            [self transferDictionaryToModelWithJSON:json];
            // 添加头部控件
            [self setupHeaderButtons];
            // 添加tableViews
            [self setupContentView];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } else {
            if (error == nil) {
                [SMNavigationController modalGlobalLoginViewController];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
//            [SMNavigationController modalGlobalLoginViewController];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            notice.mode = MBProgressHUDModeText;
//            notice.labelText = @"加载失败！";
//            notice.yOffset = -30;
//            [notice hide:YES afterDelay:2.0];
        }
    }];
}

/**
 *  字典转模型
 */
- (void)transferDictionaryToModelWithJSON:(id)json
{
    // 字典转模型
    for (NSDictionary *lessonGroupDict in json[@"lessonGroups"]) {
        SMCourseLessonGroup *lessonGroup = [SMCourseLessonGroup groupWithDict:lessonGroupDict];
        for (NSDictionary *lessonDict in lessonGroup.lessonsArr) {
            SMCourseLesson *lesson = [SMCourseLesson lessonWithDict:lessonDict];
            SMCourseTeacher *teacher = [SMCourseTeacher teacherWithDict:lessonDict[@"teacher"]];
            lesson.teacher = teacher;
            [lessonGroup.lessonModelsArr addObject:lesson];
        }
        [self.lessonSectionArr addObject:lessonGroup];
    }
}
#pragma mark - 创建页面的一些子控件
/**
 *  设置标题文字
 */
- (void)setupTitleView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text = NSLocalizedString(@"LESSONS_PAGE_LESSONS", nil);
    titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}

/**
 *  导航栏
 */
- (void)setupNav
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_details_back.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
}

/**
 *  头部控件
 */
- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SMScreenWidth, 44);
    [self.view addSubview:headerView];
    headerView.backgroundColor = colorWithRGB(240, 243, 245);
    self.headerView = headerView;
    
    // 分割线
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = colorWithRGB(178, 230, 239);
    [headerView addSubview:sepLine];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.left).offset(10);
        make.right.equalTo(headerView.right).offset(-10);
        make.bottom.equalTo(headerView.bottom);
        make.height.equalTo(1);
    }];
    self.sepLine = sepLine;
    
}

/**
 *  添加头部控件
 */
- (void)setupHeaderButtons
{
    // 增加顶部按钮
    NSInteger count = self.lessonSectionArr.count;
    for (NSInteger i = 0; i < count; i++) {
        // 课程数量
        UIButton *courseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        courseBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        courseBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        courseBtn.tag = i;
        [courseBtn setTitleColor:colorWithRGB(120, 221, 243) forState:UIControlStateDisabled];
        [courseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [courseBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArr addObject:courseBtn];
        SMCourseLessonGroup *lessonGroup = self.lessonSectionArr[i];
        [courseBtn setTitle:lessonGroup.title forState:UIControlStateNormal];
        [self.headerView addSubview:courseBtn];
        
        [courseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.top);
            make.bottom.equalTo(self.sepLine.top);
            make.width.equalTo(SMScreenWidth / count);
        }];
        
        if (count == 1) {
            [courseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.headerView.centerX);
            }];
            
            [self headerButtonClick:self.buttonsArr[0]];
            SMCourseLessonGroup *lessonGroup = self.lessonSectionArr[0];
            NSString *lessonGroupID = [NSString stringWithFormat:@"%ld",lessonGroup.ID];
            [[PiwikTracker sharedInstance] sendViews:@"courses",_ID,@"lesson_group",lessonGroupID, nil];
        } else if (count && count > 1){
            if (i == 0) {
                [courseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.headerView.left);
                }];
                [self headerButtonClick:self.buttonsArr[0]];
            } else {
                UIButton *curBtn = self.buttonsArr[i];
                UIButton *preBtn = self.buttonsArr[i - 1];
                [curBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(preBtn.right);
                }];
            }
        }
    }
}

/**
 *  设置tableVIew
 */
- (void)setupContentView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.frame = CGRectMake(0, 44, SMScreenWidth, SMScreenHeight);
    scrollView.contentSize = CGSizeMake(SMScreenWidth * self.lessonSectionArr.count, SMScreenHeight);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (NSInteger i = 0; i < self.lessonSectionArr.count; i++) {
        SMTableViewController *tbVc = [[SMTableViewController alloc] init];
        tbVc.view.backgroundColor = colorWithRGB(240, 243, 245);
        SMCourseLessonGroup *lessonGroup = self.lessonSectionArr[i];
        tbVc.lessonsArr = lessonGroup.lessonModelsArr;
        [self addChildViewController:tbVc];
        tbVc.view.frame = CGRectMake(i * SMScreenWidth, 0, SMScreenWidth, SMScreenHeight);
        [scrollView addSubview:tbVc.view];
        [tbVc.tableView reloadData];
    }
}
#pragma mark - 监听顶部按钮点击
/**
 *  顶部按钮点击
 */
- (void)headerButtonClick:(UIButton *)button
{
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    // 跳转tableView
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = button.tag * SMScreenWidth;
    SMCourseLessonGroup * lessonGroup = self.lessonSectionArr[button.tag];
    NSString * lessonGroupID = [NSString stringWithFormat:@"%ld",lessonGroup.ID];
    [[PiwikTracker sharedInstance] sendViews:@"courses",_ID,@"lesson_group",lessonGroupID, nil];

    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 左侧菜单
- (void)openOrCloseLeftList
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / SMScreenWidth;
    [self headerButtonClick:self.buttonsArr[index]];
}

#pragma mark - dealloc
- (void)dealloc
{
    SMLog(@"-- course controller 挂了---- ");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
