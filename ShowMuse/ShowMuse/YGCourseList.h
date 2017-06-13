//
//  YGCourseList.h
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMWatchState;

@interface YGCourseList : NSObject

/** 课程ID */
@property (assign, nonatomic) NSInteger ID;
/** 课程标题 */
@property (copy, nonatomic) NSString *title;
/** 视频图片 */
@property (copy, nonatomic) NSString *thumb;
/** 观看总次数 */
@property (assign, nonatomic) NSInteger viewsTotal;
/** 喜欢总数 */
@property (assign, nonatomic) NSInteger likesTotal;
/** 评论总数 */
@property (assign, nonatomic) NSInteger commentsTotal;
/** 观看进度 */
@property (assign, nonatomic) NSInteger videoWatchProgress;
/** 是否对用户枷锁 */
@property (assign, nonatomic, getter=isLockedToUser) BOOL isLockedToUser;

@property (assign, nonatomic, getter=isPremium) BOOL premium;
/** 视频时常 */
@property (copy, nonatomic) NSString *videoDurationTime;

@property (assign, nonatomic, getter=isNewCourse) BOOL newCourse;
/** Watch State */
@property (strong, nonatomic) SMWatchState *watchState;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)listWithDict:(NSDictionary *)dict;


@end
