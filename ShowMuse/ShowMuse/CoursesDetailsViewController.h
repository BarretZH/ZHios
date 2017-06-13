//
//  CoursesDetailsViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UMSocial.h"

@class LessonModel, SMWatchState, SMVideoQuestion;

@interface CoursesDetailsViewController : UIViewController/*<UMSocialUIDelegate>*/

/** 课程的ID */
@property (copy, nonatomic) NSString *lessonID;

/** 保存课程的模型数据 */
@property (strong, nonatomic) LessonModel *lesson;

/** 保存观看状态模型 */
@property (strong, nonatomic) SMWatchState *watchState;

/** 保存问题模型 */
@property (strong, nonatomic) SMVideoQuestion *question;

@property (strong, nonatomic) UIView *tView;


@end
