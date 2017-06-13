//
//  SMLessonGroup.h
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SMLessonGroup : NSObject

/** 相关课程ID */
@property (copy, nonatomic) NSString *ID;

/** 课程标题 */
@property (copy, nonatomic) NSString *title;

/** 课程总数 */
@property (assign, nonatomic) NSInteger totalLessons;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)groupWithDict:(NSDictionary *)dict;

@end
