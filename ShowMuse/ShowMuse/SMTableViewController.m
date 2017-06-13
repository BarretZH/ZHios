//
//  SMTableViewController.m
//  ShowMuse
//
//  Created by liuyonggang on 12/6/2016.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMTableViewController.h"
#import "CoursesTableViewCell.h"
#import "SMCourseLesson.h"
#import "YGMasterMainViewController.h"
#import "SMCourseTeacher.h"
#import "VIPShopViewController.h"
#import "CoursesDetailsViewController.h"
#import "SMLessonDetailController.h"
#import "TokenManager.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
/** cell的循环利用标识 */
static NSString * const SMCourseDetailsCellIdentifier = @"CourseCell";

@interface SMTableViewController () <CoursesTableViewCellDelegate, UIAlertViewDelegate>

@end

@implementation SMTableViewController

#pragma mark - lazy
- (NSMutableArray *)lessonsArr
{
    if (!_lessonsArr) {
        _lessonsArr = [NSMutableArray array];
    }
    return _lessonsArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 108, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CoursesTableViewCell class]) bundle:nil] forCellReuseIdentifier:SMCourseDetailsCellIdentifier];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lessonsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CoursesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SMCourseDetailsCellIdentifier];
    cell.delegate = self;
    cell.lesson = self.lessonsArr[indexPath.row];
    return cell;
}

#pragma mark - CoursesTableViewCellDelegate
- (void)CourseCellIconButtonDidClick:(UIButton *)iconButton
{
    // 获取cell的indexPath
    UIView *contenView= [iconButton superview];
    CoursesTableViewCell *cell = (CoursesTableViewCell *)[contenView superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // 界面跳转
    SMCourseLesson *lesson = self.lessonsArr[indexPath.row];
    YGMasterMainViewController *mMVc = [[YGMasterMainViewController alloc] init];
    mMVc.teacherID = lesson.teacher.ID;
    [self.navigationController pushViewController:mMVc animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *msgLogin = [defaults objectForKey:@"40301"];
    NSString *msgVIP = [defaults objectForKey:@"40302"];
    
    SMCourseLesson *lesson = self.lessonsArr[indexPath.row];
    if (lesson.isLockedToUser) { // 枷锁
        if ([TokenManager getGuest]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgLogin delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 100;
            [alertView show];
        } else {
            UIAlertView *guestAlert = [[UIAlertView alloc] initWithTitle:nil message:msgVIP delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            guestAlert.tag = 200;
            [guestAlert show];
        }
    } else {
//        CoursesDetailsViewController *detailVc = [[CoursesDetailsViewController alloc] init];
//        detailVc.lessonID  = [NSString stringWithFormat:@"%ld", lesson.ID];
//        [self.navigationController pushViewController:detailVc animated:YES];
        
        SMLessonDetailController *detailVc = [[SMLessonDetailController alloc] init];
        detailVc.lessonID = [NSString stringWithFormat:@"%ld", lesson.ID];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) { // 游客登录
        if (buttonIndex == 1) {
            if (buttonIndex == 1) { // 确认按钮
                
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
    } else {
        if (buttonIndex == 1) {
            VIPShopViewController *vip = [[VIPShopViewController alloc] init];
            [self.navigationController pushViewController:vip animated:YES];
        }
    }
}

@end
