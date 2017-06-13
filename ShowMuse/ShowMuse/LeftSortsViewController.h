//
//  LeftSortsViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/4.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftSortsViewController : UIViewController

@property (copy, nonatomic)NSString * str;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *userButton;

@property (weak, nonatomic) IBOutlet UILabel *messageNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *messageNumberView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *VIPButton;
@property (weak, nonatomic) IBOutlet UIButton *teacherButton;


@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


-(void)showmuse;
@end




