//
//  SMSubscribeView.m
//  ShowMuse
//
//  Created by ygliu on 8/18/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "SMSubscribeView.h"
#import "Masonry.h"

@implementation SMSubscribeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWidgets];
    }
    return self;
}

- (void)setupWidgets
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5;
    
    UIButton *SubscribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:SubscribeBtn];
    SubscribeBtn.backgroundColor = [UIColor clearColor];
    [SubscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SubscribeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [SubscribeBtn addTarget:self action:@selector(subscribeBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [SubscribeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.leading.equalTo(self.mas_leading).offset(20);
        make.bottom.equalTo(self.mas_bottom);
        make.trailing.equalTo(self.mas_trailing).offset(-20);
    }];
    
    UILabel *subscribeLabel = [[UILabel alloc] init];
    subscribeLabel.textColor = [UIColor whiteColor];
    subscribeLabel.textAlignment = NSTextAlignmentCenter;
    subscribeLabel.font = [UIFont systemFontOfSize:14.0];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"THIS_IS_TRAILER", nil)];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:NSLocalizedString(@"SUBSCRIBE_COLOR", nil)].location, [[noteStr string] rangeOfString:NSLocalizedString(@"SUBSCRIBE_COLOR", nil)].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:colorWithRGBA(89, 212, 234, 1) range:redRange];
    [subscribeLabel setAttributedText:noteStr];
    [self addSubview:subscribeLabel];
    
    [subscribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.bottom.equalTo(SubscribeBtn);
    }];

}

- (void)subscribeBtnDidClick
{
    if (self.tapSubscribe) {
        self.tapSubscribe();
    }
}

@end
