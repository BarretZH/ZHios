//
//  CoursesTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/12.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMCourseLesson, SMCourseTeacher;
@protocol CoursesTableViewCellDelegate <NSObject>

@optional
- (void)CourseCellIconButtonDidClick:(UIButton *)iconButton;

@end

@interface CoursesTableViewCell : UITableViewCell

@property (weak, nonatomic) id<CoursesTableViewCellDelegate> delegate;

/** 课程的模型 */
@property (strong, nonatomic) SMCourseLesson *lesson;

@end
