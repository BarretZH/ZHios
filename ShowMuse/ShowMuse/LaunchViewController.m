//
//  LaunchViewController.m
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "LaunchViewController.h"

#import "LoginViewController.h"

#import "RegisterViewController.h"

#import "HomeViewController.h"

#import "LeftSortsViewController.h"

#import "AppDelegate.h"

//#import "LoginNetWork.h"

#import "TokenManager.h"

#import "AFNetworking.h"

@interface LaunchViewController ()<UIScrollViewDelegate>{
    UIScrollView * _scrollView;
    
    UIPageControl * _pageControl;
}
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) NSMutableArray * imgArr;
@end

@implementation LaunchViewController
- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return _manager;
}
- (NSMutableArray *)imgArr
{
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

-(BOOL)shouldAutorotate
{
    
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guestLogin:) name:@"appPreferences" object:nil];
    

    [self.loginButton setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
    [self.RegistrationButton setTitle:NSLocalizedString(@"REGISTRATION", nil) forState:UIControlStateNormal];
    self.noAccountLabel.text = NSLocalizedString(@"ON_ACCOUNT", nil);
    
    
    
    UIImage * img0 = [UIImage imageNamed:NSLocalizedString(@"LAUNCH_ONE", nil)];
    UIImage * img1 = [UIImage imageNamed:NSLocalizedString(@"LAUNCH_TWO", nil)];
    UIImage * img2 = [UIImage imageNamed:NSLocalizedString(@"LAUNCH_THREE", nil)];
//    UIImage * img3 = [UIImage imageNamed:NSLocalizedString(@"LAUNCH_FOUR", nil)];
    NSArray * arr = @[img0,img1,img2];
    [self.imgArr addObjectsFromArray:arr];
    SMLog(@"-----img-----%lu",(unsigned long)self.imgArr.count);
    [self.view addSubview:[self scrollViewWithNSArray:arr]];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SMScreenHeight-80, /*[UIScreen mainScreen].bounds.size.width*/self.view.size.width, 40)];
    _pageControl.numberOfPages = self.imgArr.count;
    
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:125/255.0 green:127/255.0 blue:128/255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:_pageControl];
    
    
    UIView * footView = _loginView;
    [self.view addSubview:footView];

    
}



#pragma mark - 图片滑动视图
-(UIScrollView *)scrollViewWithNSArray:(NSArray *)imageArray {
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-_loginView.bounds.size.height)];
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.pagingEnabled = YES;
//    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*imageArray.count, self.view.frame.size.height-_loginView.bounds.size.height);
     _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*imageArray.count, [UIScreen mainScreen].bounds.size.height);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    for (int i =0; i<imageArray.count;i++) {
        UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        imageButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-_loginView.bounds.size.height);
        imageButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //        [imageButton setImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
        [imageButton setBackgroundImage:[imageArray objectAtIndex:i] forState:UIControlStateNormal];
        imageButton.tag = i;
        [imageButton addTarget:self action:@selector(scrollViewImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:imageButton];
    }
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    //设置代理
    _scrollView.delegate = self;
    
    
    return _scrollView;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = _scrollView.contentOffset.x/self.view.frame.size.width;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_scrollView.contentOffset.x > [UIScreen mainScreen].bounds.size.width*(self.imgArr.count-1)) {
        //进入主页
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
//            SMLog(@"00000000000000000000");
            [self gotoHomeViewController];
        });
        
//        [self gotoHomeViewController];
//        [self loginViewController];
//        if (_loginSucc) {
//            _loginSucc();
//        }
//        LoginViewController * VC = [[LoginViewController alloc] init];
//        UINavigationController * LoginNav = [[UINavigationController alloc] initWithRootViewController:VC];
//        LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        
//        [self presentViewController:LoginNav animated:YES completion:nil];
    }
    
}
#pragma mark - 点击滑动视图上的图片的方法
-(void)scrollViewImageButtonClick:(UIButton *)imageButton {
//    if (_scrollView.contentOffset.x > [UIScreen mainScreen].bounds.size.width*2) {
//        
//    }else {
        [_scrollView setContentOffset:CGPointMake((_pageControl.currentPage+1)*[UIScreen mainScreen].bounds.size.width, 0) animated:YES];
        _pageControl.currentPage = _pageControl.currentPage+1;
//    }
}




//#pragma mark - 登录
//- (IBAction)gotoLogin:(id)sender {
//    [self loginViewController];
////    if (_loginSucc) {
////        _loginSucc();
////    }
//    
//}


//#pragma mark - 注册
//- (IBAction)gotoRegister:(id)sender {
//    
//    RegisterViewController * VC = [[RegisterViewController alloc] init];
//    SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
//    LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    [self presentViewController:LoginNav animated:YES completion:nil];
//
//    
//}





//- (void)loginViewController {
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    LoginViewController * VC = [LoginViewController sharedLoginController];
//    VC.loginSucc = ^ {
//        [tempAppDelegate gotoHomeViewController];
//    };
//    SMNavigationController *LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
//    LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    
//    [self presentViewController:LoginNav animated:YES completion:nil];
//
//}






#pragma mark - 进入主页
-(void)gotoHomeViewController {
//    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
//    BOOL guestAsUser = [[userDefaults objectForKey:@"guestAsUser"] boolValue];
//    SMLog(@"和用户一样？-----%d",guestAsUser);
//    [LoginNetWork guestLoginComplete:^(id json, NSError *error) {
//        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (json != nil) {
//            NSString * access_token = json[@"access_token"];
//            if (guestAsUser) {
//                [TokenManager saveeGuest:0];
//            }else {
//                [TokenManager saveeGuest:1];
//            }
//            //            [TokenManager saveeGuest:1];
//            [TokenManager saveToken:access_token];
//            //            if (_loginSucc) {
//            //                _loginSucc();
//            //            }
//            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [tempAppDelegate gotoHomeViewController];
//            
//        }else {
//            if (error) {
//                //                NSDictionary * dict = (NSDictionary *)error;
//                //                MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                //                notice.mode = MBProgressHUDModeText;
//                //                notice.labelText = dict[@"message"];
//                //                notice.yOffset = -40;
//                //                [notice hide:YES afterDelay:3.0];
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }
//    }];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate gotoHomeViewController];
}
-(void)guestLogin:(NSNotification *)note {
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    BOOL guestAsUser = [[userDefaults objectForKey:@"guestAsUser"] boolValue];
    SMLog(@"和用户一样？-----%d",guestAsUser);
//    [LoginNetWork guestLoginComplete:^(id json, NSError *error) {
//        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (json != nil) {
//            NSString * access_token = json[@"access_token"];
//            if (guestAsUser) {
//                [TokenManager saveeGuest:0];
//            }else {
//                [TokenManager saveeGuest:1];
//            }
//            [TokenManager saveToken:access_token];
//            
//        }else {
//            if (error) {
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }
//    }];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    NSDictionary *requestParameters = @{
                                        @"grant_type":@"guest",
                                        @"device_id":identifierStr,
                                        @"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",
                                        @"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"
                                        };
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/oauth/v2/token"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * access_token = responseObject[@"access_token"];
        if (guestAsUser) {
            [TokenManager saveeGuest:0];
        }else {
            [TokenManager saveeGuest:1];
        }
        [TokenManager saveToken:access_token];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
    }];
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
