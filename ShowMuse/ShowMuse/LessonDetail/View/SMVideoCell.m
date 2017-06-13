//
//  SMVideoCell.m
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMVideoCell.h"
#import "Masonry.h"
#import "SMLesson.h"
#import "UIImageView+WebCache.h"
#import "SMSubscribeView.h"

@interface SMVideoCell ()

@property (weak, nonatomic) UIImageView *videoBgView;

@property (nonatomic,strong) UIButton *playView;

@property (strong, nonatomic) UIView *coverView;

@property (strong, nonatomic) SMSubscribeView *subscribe;

@end

@implementation SMVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addChildWidgets];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addChildWidgets
{
    UIImageView *videoBgView = [[UIImageView alloc] init];
    videoBgView.userInteractionEnabled = YES;
    videoBgView.tag = 101;
    _videoBgView = videoBgView;
    [self.contentView addSubview:videoBgView];
    [_videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.leading.equalTo(self.contentView.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing);
        make.height.mas_equalTo(round(SMScreenWidth * 9 / 16));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.videoBgView addSubview:coverView];
    _coverView = coverView;
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoBgView);
    }];
    
    _playView = [[UIButton alloc] init];
    [self.videoBgView addSubview:_playView];
    [_playView addTarget:self action:@selector(playButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_playView setImage:[UIImage imageNamed:@"icon_course_play"] forState:UIControlStateNormal];
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.videoBgView.mas_centerX);
        make.centerY.equalTo(self.videoBgView.mas_centerY);
        make.width.and.height.equalTo(@(44));
    }];
    
    SMSubscribeView *subscribe = [[SMSubscribeView alloc] init];
    [self.videoBgView addSubview:subscribe];
    self.subscribe = subscribe;
    [subscribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.videoBgView.mas_leading);
        make.trailing.equalTo(self.videoBgView.mas_trailing);
        make.bottom.equalTo(self.videoBgView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
}

- (void)playButtonDidClick:(UIButton *)button
{
    if (self.playBlock) {
        self.playBlock(button);
    }
}

@end
