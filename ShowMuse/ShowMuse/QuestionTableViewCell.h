//
//  QuestionTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/10.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Courses;

@interface QuestionTableViewCell : UITableViewCell

/** 课程模型 */
@property (strong, nonatomic) Courses *course;


@end
