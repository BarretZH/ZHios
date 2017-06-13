//
//  RegisterViewController.m
//  ShowMuse
//
//  Created by show zh on 16/4/28.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "RegisterViewController.h"

#import "AppDelegate.h"

#import "LoginNetWork.h"

#import "AFNetworking.h"

#import "MBProgressHUD.h"

#import "LoginViewController.h"




@interface RegisterViewController ()
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation RegisterViewController
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
//    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.0];
    

    
    self.emailTextField.tintColor = [UIColor whiteColor];
    self.passwordTextField.tintColor = [UIColor whiteColor];

    [_emailTextField setValue:[UIColor colorWithRed:199/255.0 green:194/255.0 blue:191/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    _emailTextField.placeholder = NSLocalizedString(@"LOGIN_EMAIL", nil);
    _passwordTextField.placeholder = NSLocalizedString(@"LOGIN_PASSWORD", nil);
    [_passwordTextField setValue:[UIColor colorWithRed:199/255.0 green:194/255.0 blue:191/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];

    

    [_emailTextField addTarget:self  action:@selector(emailTextChange:)  forControlEvents:UIControlEventAllEditingEvents];
    [_passwordTextField addTarget:self  action:@selector(passWordTextChange:)  forControlEvents:UIControlEventAllEditingEvents];
    
    
    self.titleLabel.text = NSLocalizedString(@"LOGIN_REGISTRATION", nil);
    [self.registerNowButton setTitle:NSLocalizedString(@"LOGIN_REGISTER_NOW", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}



#pragma mark - 注册
- (IBAction)buttonClick:(id)sender {
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    if ([predicate evaluateWithObject:_emailTextField.text]&&![_passwordTextField.text isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LoginNetWork registerWithEmail:_emailTextField.text password:_passwordTextField.text complete:^(id json, NSError *error) {
            if (json) {
                //注册成功
                NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
                
                [userDefaults setObject:_emailTextField.text forKey:@"user_email"];
                
                [userDefaults synchronize];

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                LoginViewController * VC = [LoginViewController sharedLoginController];
                VC.emailTextField.text = self.emailTextField.text;
                VC.loginSucc = ^ {
                    [tempAppDelegate gotoHomeViewController];
                };
                SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
                LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                
                [self presentViewController:LoginNav animated:YES completion:nil];
//                [self showAlert:json[@"message"]];
                [self showAlertView:json[@"message"]];
                
                
            }else {
                if (error) {
                    NSDictionary * dic = (NSDictionary *)error;
                    
                    //                [self showAlert:dic[@"message"]];
                    [self showAlertView:dic[@"message"]];
                }else {
                    [SMNavigationController modalGlobalLoginViewController];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
        }];
        
//        NSDictionary* requestParameters = @{@"email":_emailTextField.text,@"password":_passwordTextField.text};
//        [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/register"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            //注册成功
//            NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
//            
//            [userDefaults setObject:_emailTextField.text forKey:@"user_email"];
//            
//            [userDefaults synchronize];
//            
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            LoginViewController * VC = [LoginViewController sharedLoginController];
//            VC.emailTextField.text = self.emailTextField.text;
//            VC.loginSucc = ^ {
//                [tempAppDelegate gotoHomeViewController];
//            };
//            SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
//            LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            
//            
//            [self presentViewController:LoginNav animated:YES completion:nil];
//            //                [self showAlert:json[@"message"]];
//            [self showAlertView:responseObject[@"message"]];
//
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if (error) {
//                NSDictionary * dic = (NSDictionary *)error;
//                
//                [self showAlertView:dic[@"message"]];
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        }];

    }else {
        //输入不正确
        if ([_emailTextField.text isEqualToString:@""]&&[_passwordTextField.text isEqualToString:@""]) {
            [self showMessage:NSLocalizedString(@"REGISTER_POPUP_EMAIL_PASSWORD", nil)];
        } else if ([_emailTextField.text isEqualToString:@""]) {
//            [self showMessage:@"请输入邮箱"];
        } else if ([_passwordTextField.text isEqualToString:@""]) {
//            [self showMessage:@"请输入密码"];
        } else if (![predicate evaluateWithObject:_emailTextField.text]) {
            [self showMessage:NSLocalizedString(@"LOGIN_EMAIL_IS_NOT_CORRECT", nil)];
        }
    }
    
    
    
}

//返回
- (IBAction)goBackButtonClick:(id)sender {
    if (_isLogin) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        LoginViewController * VC = /*[LoginViewController sharedLoginController]*/[[LoginViewController alloc] init];
        VC.loginSucc = ^ {
            [tempAppDelegate gotoHomeViewController];
        };
        SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
        LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        tempAppDelegate.window.rootViewController = LoginNav;
//        [self presentViewController:LoginNav animated:YES completion:nil];

    }

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
- (IBAction)deleteAllButtonClick:(UIButton *)sender {
    if (sender.tag == 10) {
        _emailTextField.text = @"";
    }
    if (sender.tag == 20) {
        _passwordTextField.text = @"";
    }
    sender.alpha = 0;

    
}











-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - 提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}



-(void)showAlertView:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil) otherButtonTitles:nil, nil] show];
}


//提示
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
    showview.frame = CGRectMake((self.view.bounds.size.width - LabelSize.width - 20)/2, /*self.view.bounds.size.height - */100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}



- (void)dealloc
{
    SMLog(@"---注册-----挂了---------");
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
