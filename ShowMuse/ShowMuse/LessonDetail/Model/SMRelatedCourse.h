//
//  SMRelatedCourse.h
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRelatedCourse : NSObject

@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,copy) NSString *title;

+ (instancetype)relatedCourseWithDict:(NSDictionary *)dict;

@end
