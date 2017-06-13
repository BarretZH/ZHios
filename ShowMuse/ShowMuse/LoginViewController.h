//
//  LoginViewController.h
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSingleton.h"
//#define UmengAppkey @"5715dbcae0f55a874a000ba1"//测试版
//#define UmengAppkey @"574e47a9e0f55a1201000bae"//正式版
typedef void(^loginSucc)(void);
//#import "UMSocial.h"



@interface LoginViewController : UIViewController<UIActionSheetDelegate/*,
UMSocialUIDelegate*/>


@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


//@property (strong, nonatomic) LeftSlideViewController * 
//@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) loginSucc loginSucc;

@property (weak, nonatomic) IBOutlet UIButton *emailClearButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordClearButton;



@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (copy, nonatomic) NSString * emailStr;

SMSingletonH(LoginController);
-(void)showSkipButton;
@end
