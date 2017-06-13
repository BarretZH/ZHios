//
//  SMTeacherIntroCell.m
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMTeacherIntroCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "SMLesson.h"
#import "SMCourseTeacher.h"
#import "YGTeacherCourse.h"

@interface SMTeacherIntroCell ()

@property (nonatomic,weak) UIButton *likeBtn;

@property (nonatomic,weak) UILabel *introLabel;

@property (nonatomic,weak) UIImageView *iconView;

@property (nonatomic,weak) UILabel *teaNameLabel;

@property (nonatomic,weak) UILabel *lessonNameLabel;

@property (nonatomic,weak) SMIntroButton *shopBtn;

@end

@implementation SMIntroButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat width = 18;
    CGFloat x = (contentRect.size.width - width) * 0.5;
    CGFloat y = (contentRect.size.height - width - 20) * 0.5;
    return CGRectMake(x, y, width, width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat y = CGRectGetMaxY(self.imageView.frame);
    return CGRectMake(0, y, contentRect.size.width, 20);
}

@end

@implementation SMTeacherIntroCell

- (void)setLesson:(SMLesson *)lesson
{
    _lesson = lesson;
    
    self.lessonNameLabel.text = lesson.title;
    self.introLabel.text = lesson.introduction;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.lesson.teacherModel.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconView.image = [image circleImage];
    }];
    self.teaNameLabel.text = lesson.teacherModel.name;
    self.introLabel.height = lesson.introLabelH;
    self.likeBtn.selected = lesson.isLikedByUser ? YES : NO;
    self.shopBtn.hidden = lesson.relatedProductArr.count == 0 ? YES : NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWidgets];
        self.contentView.backgroundColor = colorWithRGB(238, 241, 243);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupWidgets
{
    UILabel *lessonNameLabel = [[UILabel alloc] init];
//    lessonNameLabel.backgroundColor = [UIColor randomColor];
    lessonNameLabel.textAlignment = NSTextAlignmentLeft;
    lessonNameLabel.textColor = colorWithRGBA(48, 48, 48, 0.8);
    lessonNameLabel.font = [UIFont systemFontOfSize:17.0];
    [self.contentView addSubview:lessonNameLabel];
    self.lessonNameLabel = lessonNameLabel;
    [lessonNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@(SMScreenWidth * 0.8));
        make.height.equalTo(@(20));
    }];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.tag = 0;
    [likeBtn setImage:[UIImage imageNamed:@"icon_details_like_off"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"icon_details_like_on"] forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    likeBtn.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:likeBtn];
    self.likeBtn = likeBtn;
    
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lessonNameLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.and.height.equalTo(@(25));
    }];
    
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.numberOfLines = 0;
//    introLabel.backgroundColor = [UIColor randomColor];
    introLabel.textAlignment = NSTextAlignmentLeft;
    introLabel.font = [UIFont systemFontOfSize:15.0];
    introLabel.textColor = colorWithRGB(153, 154, 151);
    [self.contentView addSubview:introLabel];
    self.introLabel = introLabel;
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lessonNameLabel.mas_bottom).offset(5);
        make.left.equalTo(lessonNameLabel.mas_left);
        make.width.equalTo(@(SMScreenWidth * 0.8));
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.userInteractionEnabled = YES;
    [iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teacherIconTapAction:)]];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introLabel.mas_bottom).offset(10);
        make.left.equalTo(introLabel.mas_left);
        make.width.and.height.equalTo(@(44));
    }];
    
    UILabel *teaNameLabel = [[UILabel alloc] init];
    teaNameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    teaNameLabel.textColor = colorWithRGB(153, 154, 151);
    [self.contentView addSubview:teaNameLabel];
    self.teaNameLabel = teaNameLabel;
    [teaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView.mas_centerY);
        make.left.equalTo(iconView.mas_right).offset(5);
        make.height.equalTo(@(25));
        make.width.equalTo(@(SMScreenWidth-216));
    }];
    
    SMIntroButton *shareBtn = [SMIntroButton buttonWithType:UIButtonTypeCustom];
    shareBtn.tag = 1;
    [shareBtn setImage:[UIImage imageNamed:@"icon_details_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:NSLocalizedString(@"LESSONS_DETAILS_PAGE_SHARE", nil) forState:UIControlStateNormal];
    
    [self.contentView addSubview:shareBtn];
//    shareBtn.backgroundColor = [UIColor randomColor];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(teaNameLabel.mas_centerY);
        make.right.equalTo(likeBtn.mas_right);
        make.width.equalTo(@(52));
        make.height.equalTo(@(50));
    }];
    
    SMIntroButton *downloadBtn = [SMIntroButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.tag = 2;
    [downloadBtn setImage:[UIImage imageNamed:@"icon_download"] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [downloadBtn setTitle:NSLocalizedString(@"DOWNLOAD_PAGE_TITLE", nil) forState:UIControlStateNormal];
    [self.contentView addSubview:downloadBtn];
//    downloadBtn.backgroundColor = [UIColor randomColor];
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareBtn.mas_centerY);
        make.right.equalTo(shareBtn.mas_left);
        make.width.and.height.equalTo(shareBtn);
    }];
    
    SMIntroButton *shopBtn = [SMIntroButton buttonWithType:UIButtonTypeCustom];
    shopBtn.tag = 3;
    shopBtn.hidden = YES;
    [shopBtn setImage:[UIImage imageNamed:@"icon_details_shop"] forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [shopBtn setTitle:NSLocalizedString(@"LESSONS_DETAILS_PAGE_SHOP", nil) forState:UIControlStateNormal];
    [self.contentView addSubview:shopBtn];
    self.shopBtn = shopBtn;
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shareBtn.mas_centerY);
        make.trailing.equalTo(downloadBtn.mas_leading);
        make.width.and.height.equalTo(shareBtn);
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    [self.contentView addSubview:sepLine];
    sepLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_left);
        make.right.equalTo(likeBtn.mas_right);
        make.height.equalTo(@(1));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(iconView.mas_bottom).offset(15);
    }];
}

- (void)buttonDidClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(introCellButtonDidClick:)]) {
        [self.delegate introCellButtonDidClick:button];
    }
}

- (void)teacherIconTapAction:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(introCellTeacherIconTap:)]) {
        [self.delegate introCellTeacherIconTap:self.iconView];
    }
}

@end
