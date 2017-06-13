//
//  SMTeacherIntroCell.h
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMLesson;

@protocol SMTeacherIntroCellDelegate <NSObject>

@optional
- (void)introCellButtonDidClick:(UIButton *)button;
- (void)introCellTeacherIconTap:(UIImageView *)imageView;

@end
@interface SMTeacherIntroCell : UITableViewCell

@property (nonatomic,weak) id<SMTeacherIntroCellDelegate> delegate;

@property (strong, nonatomic) SMLesson *lesson;

@end


@interface SMIntroButton : UIButton


@end