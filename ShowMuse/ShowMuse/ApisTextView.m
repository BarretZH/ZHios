//
//  ApisTextView.m
//  test
//
//  Created by 陈峰 on 15/10/28.
//  Copyright © 2015年 陈峰. All rights reserved.
//

#import "ApisTextView.h"
@interface ApisTextView () {
    UITextView *placeTextView;
}
@end

@implementation ApisTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setObserver];
        [self setPlaceHolderView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setObserver];
        [self setPlaceHolderView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setObserver];
        [self setPlaceHolderView];
    }
    return self;
}

- (void)setObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setPlaceHolderView {
    placeTextView = [UITextView new];
    placeTextView.backgroundColor = [UIColor clearColor];
    placeTextView.userInteractionEnabled = NO;
    placeTextView.textColor = [UIColor colorWithWhite:170/255.f alpha:1];
    [self addSubview:placeTextView];
    [self layoutIfNeeded];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    placeTextView.frame = self.bounds;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if (self.text.length==0) {
        placeTextView.text = placeHolder;
    }
}

- (void)textChange:(NSNotification *)notification {
    if (notification.object == self) {
        if (self.text.length>0) {
            placeTextView.text = @"";
        } else {
            placeTextView.text = _placeHolder;
        }
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    placeTextView.font = font;
}

@end
