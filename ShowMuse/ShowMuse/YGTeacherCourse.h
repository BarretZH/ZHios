//
//  YGTeacherCourse.h
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YGTeacherCourse : NSObject
/** 课程ID */
@property (assign, nonatomic) NSInteger ID;
/** 老师姓名 */
@property (copy, nonatomic) NSString *name;
/** 老师介绍 */
@property (copy, nonatomic) NSString *introduction;
/** 头像 */
@property (copy, nonatomic) NSString *avatar;
/** 是否关注 */
@property (nonatomic, getter=isFavourite) BOOL favourite;

/** 计算老师详情的高度 */
@property (assign, nonatomic, readonly) CGFloat viewHeight;

/**
 *  字典转模型
 */
+ (instancetype)courseWithDict:(NSDictionary *)dict;

@end
