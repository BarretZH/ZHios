//
//  SMSubtitle.m
//  ShowMuse
//
//  Created by liuyonggang on 30/5/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMSubtitle.h"

@implementation SMSubtitle

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.number = [dict[@"number"] integerValue];
        self.startTime = [self timeWithString:dict[@"startTime"]];
        self.stopTime = [self timeWithString:dict[@"stopTime"]];
        self.text = dict[@"text"];
        
    }
    return self;
}

+ (instancetype)subtitleWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

/**
 *  根据时间字符串转为时间格式
 */
- (NSTimeInterval)timeWithString:(NSString *)time
{
    // 00:10:00,600
    NSInteger haomiao = [[time componentsSeparatedByString:@","][1] integerValue];
    NSInteger second = [[time substringWithRange:NSMakeRange(6, 2)] integerValue];
    NSInteger min = [[time substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSUInteger hour = [[time substringWithRange:NSMakeRange(0, 2)] integerValue];
    
    return (hour * 60 * 60 + min * 60 + second + haomiao * 0.001);
}

@end
