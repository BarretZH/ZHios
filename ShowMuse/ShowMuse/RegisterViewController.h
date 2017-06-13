//
//  RegisterViewController.h
//  ShowMuse
//
//  Created by show zh on 16/4/28.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol RegisterDelegate;


@interface RegisterViewController : UIViewController
//@property (nonatomic,assign)id<RegisterDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic) BOOL isLogin;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *emailClearButton;

@property (weak, nonatomic) IBOutlet UIButton *passwordClearButton;


@property (weak, nonatomic) IBOutlet UIButton *registerNowButton;


@end

//@protocol RegisterDelegate <NSObject>
//
//-(void)emailStringDelegate:(NSString *)email;
//
//@end