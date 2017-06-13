//
//  SMSuggestLessson.m
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMSuggestLessson.h"

@implementation SMSuggestLessson

+ (instancetype)sugLessonWithDict:(NSDictionary *)dict
{
    SMSuggestLessson *sugLesson = [[self alloc] init];
    [sugLesson setValuesForKeysWithDictionary:dict];
    return sugLesson;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    } else if ([key isEqualToString:@"isLockedToUser"]) {
        self.lockedToUser = [value boolValue];
    } else if ([key isEqualToString:@"isNew"]) {
        self.newLesson = [value boolValue];
    }
}

@end
