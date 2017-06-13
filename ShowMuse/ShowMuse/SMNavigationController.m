//
//  SMNavigationController.m
//  ShowMuse
//
//  Created by liuyonggang on 24/5/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMNavigationController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CoursesDetailsViewController.h"
#import "SMDownloadController.h"
#import "SMLessonDetailController.h"
#import "ZFPlayer.h"

@interface SMNavigationController ()

@end

@implementation SMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 滑动移除的功能失效,清空代理即可重新设置恢复
    self.interactivePopGestureRecognizer.delegate = nil;
    
}

-(BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[SMLessonDetailController class]]) {
        return !ZFPlayerShared.isLockScreen;
    }
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[SMLessonDetailController class]]) {
        if (ZFPlayerShared.isAllowLandscape) {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        } else {
            return UIInterfaceOrientationMaskPortrait;
        };
    }
    return UIInterfaceOrientationMaskPortrait;
}


+ (void)modalGlobalLoginViewController
{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[userDefaults objectForKey:@"invalid_grant"] isEqualToString:@"invalid_grant"]) {
        LoginViewController *VC = [LoginViewController sharedLoginController];
        VC.loginSucc = ^ {
            [tempAppDelegate gotoHomeViewController];
        };
        SMNavigationController *LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
        LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        tempAppDelegate.window.rootViewController = LoginNav;
//        [tempAppDelegate.mainNavigationController presentViewController:LoginNav animated:YES completion:nil];
        [userDefaults removeObjectForKey:@"invalid_grant"];
        [userDefaults synchronize];
    }
    if ([[userDefaults objectForKey:@"network"] isEqualToString:@"NO"]) {
        [self showMessage:NSLocalizedString(@"NO_INTERNET_CONNECTION", nil)];
    }

}

- (void)dealloc
{
    SMLog(@"--- navigationController 挂了 --- ");
}
+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(290, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
    label.frame = CGRectMake(10, 5, labelSize.width, labelSize.height);
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    [showview addSubview:label];
    showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - labelSize.width - 20)/2, /*self.view.bounds.size.height - */([UIScreen mainScreen].bounds.size.height-labelSize.height-10)/2, labelSize.width+20, labelSize.height+10);
    [UIView animateWithDuration:5.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.size = CGSizeMake(50, 30);
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [backBtn setImage:[UIImage imageNamed:@"icon_details_back.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)goBackClick
{
    [self popViewControllerAnimated:YES];
}

@end
