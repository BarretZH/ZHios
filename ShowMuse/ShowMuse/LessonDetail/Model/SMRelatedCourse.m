//
//  SMRelatedCourse.m
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMRelatedCourse.h"

@implementation SMRelatedCourse

+ (instancetype)relatedCourseWithDict:(NSDictionary *)dict
{
    SMRelatedCourse *relatedCourse = [[self alloc] init];
    [relatedCourse setValuesForKeysWithDictionary:dict];
    return relatedCourse;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}

@end
