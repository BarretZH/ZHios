//
//  SMCourseLesson.h
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SMCourseTeacher;

@interface SMCourseLesson : NSObject

/** 评论总数 */
@property (assign, nonatomic) NSInteger commentsTotal;
/** 课程ID */
@property (assign, nonatomic) NSInteger ID;
/** 是否可以观看 */
@property (assign, nonatomic, getter=isLockedToUser) BOOL lockedToUser;
/** 赞的数量 */
@property (assign, nonatomic) NSInteger likesTotal;
/** 是否是额外的账号 */
@property (assign, nonatomic, getter=isPremium) BOOL premium;
/** 课程图片 */
@property (copy, nonatomic) NSString *thumb;
/** 课程标题 */
@property (copy, nonatomic) NSString *title;
/** 视频时长 */
@property (copy, nonatomic) NSString *videoDurationTime;
/** 观看次数 */
@property (assign, nonatomic) NSInteger viewsTotal;

@property (nonatomic) int watchProgress;

@property (nonatomic) BOOL isNew;

/** 保存老师的模型 */
@property (strong, nonatomic) SMCourseTeacher *teacher;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)lessonWithDict:(NSDictionary *)dict;

@end
