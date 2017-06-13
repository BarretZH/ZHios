//
//  CoursesTableViewCell.m
//  ShowMuse
//
//  Created by show zh on 16/5/12.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "CoursesTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SMCourseLesson.h"
#import "SMCourseTeacher.h"

#import "BadgeView.h"

@interface CoursesTableViewCell ()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 介绍 */
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
/** 观看进度 */
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
/** 视频图片 */
@property (weak, nonatomic) IBOutlet UIImageView *videoBgView;
/** 是否能播放图片 */
@property (weak, nonatomic) IBOutlet UIImageView *playView;
/** 视频时长 */
@property (weak, nonatomic) IBOutlet UIButton *durationBtn;
/** 喜欢数量 */
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
/** 观看总数 */
@property (weak, nonatomic) IBOutlet UIButton *viewsTotalBtn;
/** 评论数量 */
@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *isNewImage;


@property (strong, nonatomic) BadgeView * halfChart;
@end

@implementation CoursesTableViewCell

- (void)setLesson:(SMCourseLesson *)lesson
{
    _lesson = lesson;
    [self.iconBtn.imageView sd_setImageWithURL:[NSURL URLWithString:lesson.teacher.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.iconBtn setBackgroundImage:[image circleImage] forState:UIControlStateNormal];
    }];
    [self.commentsBtn setTitle:[NumberStr numberOfstring:lesson.commentsTotal] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NumberStr numberOfstring:lesson.likesTotal] forState:UIControlStateNormal];
    [self.viewsTotalBtn setTitle:[NumberStr numberOfstring:lesson.viewsTotal] forState:UIControlStateNormal];
    [self.videoBgView sd_setImageWithURL:[NSURL URLWithString:lesson.thumb]];
    [self.durationBtn setTitle:lesson.videoDurationTime forState:UIControlStateNormal];
    self.nameLabel.text = lesson.teacher.name;
    self.introLabel.text = lesson.title;
    if (lesson.isLockedToUser) {
        self.playView.image = [UIImage imageNamed:@"icon_course_lock"];
    } else {
        self.playView.image = [UIImage imageNamed:@"icon_course_play"];
    }
    if (lesson.isNew) {
        self.isNewImage.alpha = 1;
    }else {
        self.isNewImage.alpha = 0;
    }
    float angle = lesson.watchProgress/100.00;
    [_halfChart addAngleValue:angle andColor:colorWithRGBA(83, 211, 230, 1)];
    [_halfChart addAngleValue:(1-angle) andColor:colorWithRGBA(233, 232, 235, 1)];
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%%@",lesson.watchProgress,NSLocalizedString(@"LESSONS_DONE", nil)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.iconBtn addTarget:self action:@selector(iconButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
//    self.progressLabel.hidden = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.likeBtn.backgroundColor = [UIColor clearColor];
    self.likeBtn.contentEdgeInsets = UIEdgeInsetsMake(10, -40, 10, 0);
    
    [self.commentsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.commentsBtn.backgroundColor = [UIColor clearColor];
    self.commentsBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, -40);
    
    [self.viewsTotalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.viewsTotalBtn.backgroundColor = [UIColor clearColor];
    self.viewsTotalBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    
    self.introLabel.numberOfLines = 1;
    
    [self.durationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.durationBtn.backgroundColor = [UIColor blackColor];
    self.durationBtn.alpha = 0.3;
    [self.durationBtn setImage:[UIImage imageNamed:@"icon_course_time"] forState:UIControlStateNormal];
    
    [self.likeBtn setImage:[UIImage imageNamed:@"icon_course_praise"] forState:UIControlStateNormal];
    [self.commentsBtn setImage:[UIImage imageNamed:@"icon_course_comment"] forState:UIControlStateNormal];
    [self.viewsTotalBtn setImage:[UIImage imageNamed:@"icon_course_Browse"] forState:UIControlStateNormal];
    
    _halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [_halfChart resignFirstResponder];
//    _halfChart.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.progressView addSubview:_halfChart];
    UIImageView *progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    progressImageView.image = [UIImage imageNamed:@"course"];
    [self.progressView addSubview:progressImageView];
}

- (void)setFrame:(CGRect)frame
{
//    frame.size.height = 350;
    frame.size.width = SMScreenWidth;
    [super setFrame:frame];
}

- (void)iconButtonDidClick
{
    if ([self.delegate respondsToSelector:@selector(CourseCellIconButtonDidClick:)]) {
        [self.delegate CourseCellIconButtonDidClick:self.iconBtn];
    }
}

@end
