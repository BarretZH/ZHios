//
//  NumberStr.m
//  ShowMuse
//
//  Created by show zh on 16/8/19.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "NumberStr.h"

@implementation NumberStr
+(NSString *)numberOfstring:(NSInteger)number {
    NSString * str = @"";
    if (number < 1000) {
        str = [NSString stringWithFormat:@"%ld",(long)number];
    }else {
        if (number > 1000000) {
            float num = number/1000000.0;
            str = [NSString stringWithFormat:@"%.1fM",num];
        }else {
            float num = number/1000.0;
            str = [NSString stringWithFormat:@"%.1fK",num];
        }
    }
    
    return str;
}
@end
