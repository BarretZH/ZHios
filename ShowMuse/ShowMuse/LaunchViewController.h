//
//  LaunchViewController.h
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LeftSlideViewController.h"

typedef void(^loginSucc0)(void);

@interface LaunchViewController : UIViewController



@property (nonatomic, strong) NSArray * imageArray;


@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
//@property (strong, nonatomic) UINavigationController *mainNavigationController;

@property (strong, nonatomic) loginSucc0 launchSucc;



@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *noAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *RegistrationButton;




@end
