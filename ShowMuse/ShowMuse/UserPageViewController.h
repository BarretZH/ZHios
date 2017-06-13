//
//  UserPageViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/19.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPageViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UIButton *myQuestionButton;

@property (weak, nonatomic) IBOutlet UIButton *myBadgeButton;

@property (weak, nonatomic) IBOutlet UIButton *myConsumeButton;

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bagImageHeight;

/** 是否是deeplink标识 */
@property (assign, nonatomic, getter=isDeeplink) BOOL deeplink;
/** 按钮的tag值 */
@property (assign, nonatomic) NSInteger numberID;
@end
