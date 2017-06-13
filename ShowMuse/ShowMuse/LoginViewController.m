//
//  LoginViewController.m
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "LoginViewController.h"

//#import "LoginNetWork.h"

#import "AFNetworking.h"

#import "TokenManager.h"

#import "MBProgressHUD.h"

#import "RegisterViewController.h"

#import "HomeViewController.h"

#import "ResetPasswordViewController.h"

#import <ShareSDK/ShareSDK.h>

#import "PiwikTracker.h"
#import "SMSingleton.h"

@interface LoginViewController ()<UITextFieldDelegate>
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation LoginViewController

SMSingletonM(LoginController);
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
    
    self.emailTextField.tintColor = [UIColor whiteColor];
    self.passwordTextField.tintColor = [UIColor whiteColor];
    self.skipButton.alpha = 0;
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString * str = [userDefaults objectForKey:@"user_email"];
    
    BOOL guest_allowed = [[userDefaults objectForKey:@"guest_allowed"] boolValue];
    SMLog(@"跳过是否显示----》》》》%d-------%f-----%f",guest_allowed,SMScreenHeight,SMScreenWidth);
    if (guest_allowed) {
        //显示
        self.skipButton.alpha = 1;
    }else {
        //隐藏
        self.skipButton.alpha = 0;
    }
    
    [_emailTextField addTarget:self  action:@selector(emailTextChange:)  forControlEvents:UIControlEventAllEditingEvents];
    [_passwordTextField addTarget:self  action:@selector(passWordTextChange:)  forControlEvents:UIControlEventAllEditingEvents];
//    _emailTextField.placeholder = NSLocalizedString(@"LOGIN_EMAIL", nil);
    [_emailTextField setValue:[UIColor colorWithRed:199/255.0 green:194/255.0 blue:191/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [_emailTextField setText:str];
    if (str) {
        _emailClearButton.alpha = 1;
    }
//    _passwordTextField.placeholder = NSLocalizedString(@"LOGIN_PASSWORD", nil);
    [_passwordTextField setValue:[UIColor colorWithRed:199/255.0 green:194/255.0 blue:191/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showText) name:@"showText" object:nil];
    [self showText];
}

-(void)showText {
    _emailTextField.placeholder = NSLocalizedString(@"LOGIN_EMAIL", nil);
    _passwordTextField.placeholder = NSLocalizedString(@"LOGIN_PASSWORD", nil);
    [self.skipButton setTitle:NSLocalizedString(@"LOGIN_SKIP", nil) forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
    [self.forgetPasswordButton setTitle:NSLocalizedString(@"LOGIN_FORGET_PASSWORD", nil) forState:UIControlStateNormal];
    [self.registerButton setTitle:NSLocalizedString(@"LOGIN_REGISTER_AN_ACCOUNT", nil) forState:UIControlStateNormal];
    self.otherLabel.text = NSLocalizedString(@"LOGIN_USER_OTHER_LOGIN", nil);
    
}

-(void)showSkipButton {
    BOOL guest_allowed = [[[NSUserDefaults standardUserDefaults] objectForKey:@"guest_allowed"] boolValue];
    if (guest_allowed) {
        //显示
        self.skipButton.alpha = 1;
    }else {
        //隐藏
        self.skipButton.alpha = 0;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - 三方登录
- (IBAction)umengButtonClick:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * platformName = @"";
    UIButton * button = (UIButton *)sender;
    if (button.tag == 100) {
        //sina
        platformName = @"weibo";
        [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 [self thirdPartyLoginWithtype:platformName userID:user.uid token:user.credential.token];
             }
             
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
             
         }];

    }
    if (button.tag == 200) {
        //wxsession
        platformName = @"weixin";
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 [self thirdPartyLoginWithtype:platformName userID:user.uid token:user.credential.token];
             }
             
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
             
         }];

    }
    if (button.tag == 300) {
        //facebook
        platformName = @"facebook";
        [ShareSDK getUserInfo:SSDKPlatformTypeFacebook
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 [self thirdPartyLoginWithtype:platformName userID:user.uid token:user.credential.token];
             }
             
             else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
             
         }];

    }
    
}
#pragma mark - 三方登录请求
-(void)thirdPartyLoginWithtype:(NSString *)type userID:(NSString *)uid token:(NSString *)token {
//    [LoginNetWork thirdPartyLoginWithGrantType:type UserID:uid UserAccessToken:token Complete:^(id json, NSError *error) {
//        if (!(json == nil)) {
//            
//            NSString * access_token = json[@"access_token"];
//            [TokenManager saveToken:access_token];
//            [TokenManager saveeGuest:NO];
//            if (_loginSucc) {
//                _loginSucc();
//            }
//            if ([PiwikTracker sharedInstance].userID) {
//                [PiwikTracker sharedInstance].userID = nil;
//            }
//        }else{
//            //请求失败
//            if (error == nil) {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary* requestParameters = @{@"grant_type":type,@"device_id":identifierStr,@"user_id":uid,@"user_access_token":token,@"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",@"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"};
    [self shareLoginNetWork:requestParameters];
}

#pragma mark - 登录
- (IBAction)loginButtonClick:(id)sender {
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    if ([predicate evaluateWithObject:_emailTextField.text]&&![_passwordTextField.text isEqualToString:@""]) {
        //可以登录
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [LoginNetWork accountLoginWithUserName:_emailTextField.text password:_passwordTextField.text complete:^(id json, NSError *error) {
//            SMLog(@"登录------>>>%@------%@",json,error);
//            if (json == nil) {
//                //登录失败
//                if (error == nil) {
//                    [SMNavigationController modalGlobalLoginViewController];
//                }else {
//                    NSDictionary * dic = [[NSDictionary alloc] init];
//                    dic = (NSDictionary *)error;
//                    
//                    [self showAlertView:dic[@"error_description"]];
//                    
//                }
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            }else {
//                if ([PiwikTracker sharedInstance].userID) {
//                    [PiwikTracker sharedInstance].userID = nil;
//                }
//                //登录成功
//                NSString * access_token = json[@"access_token"];
//                [TokenManager saveToken:access_token];
//                [TokenManager saveeGuest:0];
//                if (_loginSucc) {
//                    _loginSucc();
//                }
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            }
//        }];
        NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSDictionary *requestParameters = @{
                                            @"grant_type":@"password",
                                            @"device_id":identifierStr,
                                            @"username":_emailTextField.text,
                                            @"password":_passwordTextField.text,
                                            @"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",
                                            @"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"
                                            };
        [self loginNetWorkWithparmeters:requestParameters];
    }else {
        //输入有误
        if ([_emailTextField.text isEqualToString:@""]&&[_passwordTextField.text isEqualToString:@""]) {
//            [self showMessage:@"请输入邮箱和密码"];
        } else if ([_emailTextField.text isEqualToString:@""]) {
//            [self showMessage:@"请输入邮箱"];
        } else if ([_passwordTextField.text isEqualToString:@""]) {
//            [self showMessage:@"请输入密码"];
        } else if (![predicate evaluateWithObject:_emailTextField.text]) {
            [self showMessage:NSLocalizedString(@"LOGIN_EMAIL_IS_NOT_CORRECT", nil)];
        }

    }
    
    
    
}

#pragma mark - 游客登录
- (IBAction)guestLoginButtonClick:(id)sender {
    [self.view endEditing:YES];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
//    BOOL guestAsUser = [[userDefaults objectForKey:@"guestAsUser"] boolValue];
//    SMLog(@"和用户一样？-----%d",guestAsUser);
//    __block loginSucc login = self.loginSucc;
//    [LoginNetWork guestLoginComplete:^(id json, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (json != nil) {
//            NSString * access_token = json[@"access_token"];
//            if (guestAsUser) {
//                [TokenManager saveeGuest:0];
//            }else {
//                [TokenManager saveeGuest:1];
//            }
////            [TokenManager saveeGuest:1];
//            [TokenManager saveToken:access_token];
//            if (login) {
//                login();
//            }
//        }else {
//            if (error) {
//                NSDictionary * dict = (NSDictionary *)error;
//                MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                notice.mode = MBProgressHUDModeText;
//                notice.labelText = dict[@"message"];
//                notice.yOffset = -40;
//                [notice hide:YES afterDelay:3.0];
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }
//        
//        if ([PiwikTracker sharedInstance].userID) {
//            [PiwikTracker sharedInstance].userID = nil;
//            [PiwikTracker sharedInstance].userID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        }else {
//            [PiwikTracker sharedInstance].userID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        }
//    }];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    NSDictionary *requestParameters = @{
                                        @"grant_type":@"guest",
                                        @"device_id":identifierStr,
                                        @"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",
                                        @"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"
                                        };
    [self guestLoginNetWork:requestParameters];
}










#pragma mark - 注册
- (IBAction)registerButtonClick:(id)sender {
    RegisterViewController * registerVC = [[RegisterViewController alloc] init];
    registerVC.isLogin = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - 忘记密码
- (IBAction)resetPasswordButton:(id)sender {
    ResetPasswordViewController * resetPassVC = [[ResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:resetPassVC animated:YES];
    
    
}








#pragma mark - 清空按钮
- (IBAction)deleteAllButtonClick:(UIButton *)sender {
    
    if (sender.tag == 10) {
        _emailTextField.text = @"";
    }
    if (sender.tag == 20) {
        _passwordTextField.text = @"";
    }
    sender.alpha = 0;
}



#pragma mark - touchesBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - textfield点击方法
-(void)emailTextChange:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        _emailClearButton.alpha = 0;
    }else {
        _emailClearButton.alpha = 1;
    }
    
}

-(void)passWordTextChange:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        _passwordClearButton.alpha = 0;
    }else {
        _passwordClearButton.alpha = 1;
    }

}

#pragma mark - 提示
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}



-(void)showAlertView:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil] show];
}



//提示文字
-(void)showMessage:(NSString *)message
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
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - LabelSize.width - 20)/2, /*self.view.bounds.size.height - */([UIScreen mainScreen].bounds.size.height-LabelSize.height-10)/2, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
- (void)dealloc
{
    SMLog(@"---登录-----挂了---------");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//账号登录
-(void)loginNetWorkWithparmeters:(NSDictionary *)requestParameters {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block loginSucc login = self.loginSucc;
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/oauth/v2/token"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([PiwikTracker sharedInstance].userID) {
            [PiwikTracker sharedInstance].userID = nil;
        }
        //登录成功
        NSString * access_token = responseObject[@"access_token"];
        [TokenManager saveToken:access_token];
        [TokenManager saveeGuest:0];
        if (login) {
            login();
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error == nil) {
            [SMNavigationController modalGlobalLoginViewController];
        }else {
            NSDictionary * dic = [[NSDictionary alloc] init];
            dic = (NSDictionary *)error;
            
            [self showAlertView:dic[@"error_description"]];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}
//三方登录的请求
-(void)shareLoginNetWork:(NSDictionary *)requestParameters {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block loginSucc login = self.loginSucc;
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/oauth/v2/token"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([PiwikTracker sharedInstance].userID) {
            [PiwikTracker sharedInstance].userID = nil;
        }
        //登录成功
        NSString * access_token = responseObject[@"access_token"];
        [TokenManager saveToken:access_token];
        [TokenManager saveeGuest:NO];
        if (login) {
            login();
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error == nil) {
            [SMNavigationController modalGlobalLoginViewController];
        }else {
            NSDictionary * dic = [[NSDictionary alloc] init];
            dic = (NSDictionary *)error;
            
            [self showAlertView:dic[@"error_description"]];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

}
//游客登录的请求
-(void)guestLoginNetWork:(NSDictionary *)requestParameters {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    BOOL guestAsUser = [[userDefaults objectForKey:@"guestAsUser"] boolValue];
    SMLog(@"和用户一样？-----%d",guestAsUser);
    __block loginSucc login = self.loginSucc;
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/oauth/v2/token"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([PiwikTracker sharedInstance].userID) {
            [PiwikTracker sharedInstance].userID = nil;
        }
        //登录成功
        NSString * access_token = responseObject[@"access_token"];
        [TokenManager saveToken:access_token];
        if (guestAsUser) {
            [TokenManager saveeGuest:0];
        }else {
            [TokenManager saveeGuest:1];
        }
        if (login) {
            login();
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            NSDictionary * dict = (NSDictionary *)error;
            MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            notice.mode = MBProgressHUDModeText;
            notice.labelText = dict[@"message"];
            notice.yOffset = -40;
            [notice hide:YES afterDelay:3.0];
        }else {
            [SMNavigationController modalGlobalLoginViewController];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    if ([PiwikTracker sharedInstance].userID) {
        [PiwikTracker sharedInstance].userID = nil;
        [PiwikTracker sharedInstance].userID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }else {
        [PiwikTracker sharedInstance].userID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
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
