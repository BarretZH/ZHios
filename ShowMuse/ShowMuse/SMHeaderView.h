//
//  SMHeaderView.h
//  ShowMuse
//
//  Created by 刘勇刚 on 8/2/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBadgesModel.h"
@class YGTeacherCourse;
@interface SMHeaderView : UIView
/** teacher */
@property (strong, nonatomic) YGTeacherCourse *teacher;

@property (strong, nonatomic) UserBadgesModel *badges;

@end
