//
//  SMInputView.m
//  ShowMuse
//
//  Created by ygliu on 9/29/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMInputView.h"

@implementation SMInputView

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width, bounds.size.height);
}

@end
