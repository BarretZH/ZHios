//
//  SMCourseTeacher.h
//  ShowMuse
//
//  Created by liuyonggang on 8/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCourseTeacher : NSObject

/** 老师图片 */
@property (copy, nonatomic) NSString *avatar;

/** 老师ID */
@property (copy, nonatomic) NSString *ID;

/** 老师名称 */
@property (copy, nonatomic) NSString *name;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)teacherWithDict:(NSDictionary *)dict;

@end
