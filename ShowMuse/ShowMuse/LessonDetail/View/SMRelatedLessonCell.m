//
//  SMRelatedLessonCell.m
//  ShowMuse
//
//  Created by ygliu on 9/15/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMRelatedLessonCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "SMSuggestLessson.h"

@interface SMRelatedLessonCell ()

@property (nonatomic,weak) SMRelatedLessonButton *videoBgView;

@property (nonatomic,weak) UILabel *titleLabel;

@end

@implementation SMRelatedLessonCell

- (void)setSugLesson:(SMSuggestLessson *)sugLesson
{
    _sugLesson = sugLesson;
    [self.videoBgView.imageView sd_setImageWithURL:[NSURL URLWithString:sugLesson.thumb] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.videoBgView setBackgroundImage:image forState:UIControlStateNormal];
    }];
    [self.videoBgView setImage:sugLesson.isLockedToUser ? [UIImage imageNamed:@"icon_course_lock"] : [UIImage imageNamed:@"icon_course_play"] forState:UIControlStateNormal];
    self.titleLabel.text = sugLesson.title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addChildWidgets];
    }
    return self;
}

- (void)addChildWidgets
{
    SMRelatedLessonButton *videoBgView = [[SMRelatedLessonButton alloc] init];
    videoBgView.userInteractionEnabled = NO;
    [self.contentView addSubview:videoBgView];
    self.videoBgView = videoBgView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
//    titleLabel.backgroundColor = [UIColor randomColor];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [self.videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(150 * 9 / 16);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoBgView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

@end


#pragma - mark - SMRelatedLessonButton Implementation
@implementation SMRelatedLessonButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    CGFloat imgWidth = 30;
    return CGRectMake((width - imgWidth) * 0.5 , (height - imgWidth) * 0.5, imgWidth, imgWidth);
}

@end

