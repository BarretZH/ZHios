//
//  SMTagButton.m
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMTagButton.h"

@implementation SMTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = self.height * 0.5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = colorWithRGB(215, 237, 243);
        [self setTitleColor:colorWithRGBA(48, 48, 48, 0.8) forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width = self.frame.size.width + kTagButtonPadding * 2;
}

@end
