//
//  UIColor+SMExtension.m
//  ShowMuse
//
//  Created by liuyonggang on 26/5/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "UIColor+SMExtension.h"

@implementation UIColor (SMExtension)

+ (CGFloat)randomNum
{
    return arc4random_uniform(256);
}

+ (UIColor *)randomColor
{
    return [self colorWithRed:[self randomNum]/255.0 green:[self randomNum]/255.0 blue:[self randomNum]/255.0 alpha:1.0];
}

@end
