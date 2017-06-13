//
//  HomeViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/3.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LaunchViewController.h"

@interface HomeViewController : UIViewController

@property (strong, nonatomic) LaunchViewController * launchVC;

- (IBAction)questionAndTeacherBtnClick:(UIButton *)sender;

@end
