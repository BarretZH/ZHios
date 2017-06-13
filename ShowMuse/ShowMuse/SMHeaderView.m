//
//  SMHeaderView.m
//  ShowMuse
//
//  Created by 刘勇刚 on 8/2/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "SMHeaderView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "YGTeacherCourse.h"

#import "BadgeView.h"
//#import "UserBadgesModel.h"

@interface SMHeaderView ()
/** avatar */
@property (weak, nonatomic) UIImageView *iconView;
/** teacher name */
@property (weak, nonatomic) UILabel *nameLabel;
/** intro */
@property (weak, nonatomic) UILabel *introLabel;
/** like */
@property (weak, nonatomic) UIButton *likeBtn;
/** separator line */
@property (weak, nonatomic) UIView *sepLine;

/** 徽章按钮 */
@property (weak, nonatomic) UIButton *bagBtn;
/** bagImage */
@property (weak, nonatomic) UIImageView * bagImgView;
/** 遮盖 */
@property (weak, nonatomic) BadgeView *halfChart;
/** 徽章百分比 */
@property (weak, nonatomic) UILabel * progressLabel;

@end

@implementation SMHeaderView

- (void)setTeacher:(YGTeacherCourse *)teacher
{
    _teacher = teacher;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:teacher.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconView.image = [image circleImage];
    }];
    self.nameLabel.text = teacher.name;
    self.introLabel.text = teacher.introduction;
    self.likeBtn.selected = teacher.isFavourite ? YES : NO;
    
    
}
-(void)setBadges:(UserBadgesModel *)badges {
    if (badges) {
        self.bagBtn.alpha = 1;
        _badges = badges;
        [self.bagImgView sd_setImageWithURL:[NSURL URLWithString:badges.img] placeholderImage:nil];
        
        float angle = badges.progress/100.00;
        [self.halfChart addAngleValue:angle andColor:[UIColor clearColor]/*UIColorFromRGB(0x3C60A3)*/];
        [self.halfChart addAngleValue:(1-angle) andColor:colorWithRGBA(66, 77, 88, 0.3)];
        
        self.progressLabel.text = [NSString stringWithFormat:@"%d%%",badges.progress];
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupChildWedgets];
    }
    return self;
}

- (void)setupChildWedgets
{
    UIImageView *iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    self.iconView = iconView;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(20);
        make.left.equalTo(self.left).offset(18);
        make.width.and.height.equalTo(52);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:18.0 weight:0.3];
    nameLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.top).offset(2);
        make.left.equalTo(self.iconView.right).offset(10);
        make.right.equalTo(self.right).offset(-18);
        make.height.equalTo(20);
    }];
    
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.font = [UIFont systemFontOfSize:12.0];
    introLabel.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:0.8];
    introLabel.numberOfLines = 0;
    [self addSubview:introLabel];
    self.introLabel = introLabel;
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(5);
        make.left.equalTo(self.nameLabel.left);
        make.right.equalTo(self.nameLabel.right);
        make.height.greaterThanOrEqualTo(20);
    }];
    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_no"] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"heart_"] forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:likeBtn];
    self.likeBtn = likeBtn;
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.bottom).offset(2);
        make.centerX.equalTo(self.iconView.centerX);
        make.width.and.height.equalTo(25);
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = colorWithRGB(208, 208, 208);
    [self addSubview:sepLine];
    self.sepLine = sepLine;
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(18);
        make.right.equalTo(self.right).offset(-18);
        make.bottom.equalTo(self.bottom);
        make.height.equalTo(1);
    }];
    
    float width = 80.0;
    float height = 30.0;
    
    UIButton *bagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bagBtn.frame = CGRectMake(SMScreenWidth-(width-height/2), 7, width, height);
    bagBtn.backgroundColor = colorWithRGBA(0, 194, 224, 1);
    bagBtn.layer.cornerRadius = 15;
    [bagBtn addTarget:self action:@selector(bagBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bagBtn];
    self.bagBtn = bagBtn;
    self.bagBtn.alpha = 0;
    
    UIImageView * bagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, height-6, height-6)];
    [bagBtn addSubview:bagImgView];
    self.bagImgView = bagImgView;
    
    BadgeView *halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, bagImgView.frame.size.width, bagImgView.frame.size.width)];
    [halfChart resignFirstResponder];
    [bagImgView addSubview:halfChart];
    self.halfChart = halfChart;
    
    UILabel * progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(bagImgView.frame.origin.x+bagImgView.frame.size.width+2, 0, width-height/2-(bagImgView.frame.origin.x+bagImgView.frame.size.width+2), height)];
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.font = [UIFont systemFontOfSize:12.0];
    [bagBtn addSubview:progressLabel];
    self.progressLabel = progressLabel;

}


- (void)likeButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
    NSString * isLike = @"";
    if (self.teacher.isFavourite) {
        isLike = @"1";
    }else {
        isLike = @"0";
    }
    NSDictionary *dict = @{@"teacherID":[NSString stringWithFormat:@"%ld",self.teacher.ID],@"isFavourite":isLike};
    NSNotification *notification =[NSNotification notificationWithName:@"likeTeacher" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)bagBtnClick {
    NSNotification *notification =[NSNotification notificationWithName:@"TeacherBadgeClick" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
