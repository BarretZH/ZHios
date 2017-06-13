//
//  YGVideoCell.m
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

#import "YGVideoCell.h"
#import "YGCourseList.h"
#import "UIImageView+WebCache.h"
#import "SMWatchState.h"

#import "BadgeView.h"

@interface YGVideoCell ()
/**
 *  视频图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
/**
 *  视频名称
 */
@property (weak, nonatomic) IBOutlet UILabel *videoName;
/**
 *  观看次数
 */
@property (weak, nonatomic) IBOutlet UIButton *viewTotalBtn;
/**
 *  视频时长
 */
@property (weak, nonatomic) IBOutlet UIButton *videoDurationBtn;
/**
 *  是否能播放图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *isNewImage;


@property (strong, nonatomic) BadgeView * halfChart;

@end

@implementation YGVideoCell

#pragma mark - setter方法
- (void)setCourse:(YGCourseList *)course
{
    _course = course;
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:course.thumb]];
    self.videoName.text = course.title;
    [self.videoDurationBtn setTitle:course.videoDurationTime forState:UIControlStateNormal];
    // 是否加锁
    if (course.isLockedToUser) {
        self.playImage.image = [UIImage imageNamed:@"icon_course_lock"];
    } else {
        self.playImage.image = [UIImage imageNamed:@"icon_course_play"];
    }
    // 观看次数
    [self.viewTotalBtn setTitle:[NumberStr numberOfstring:course.viewsTotal] forState:UIControlStateNormal];
    if (course.isNewCourse) {
        self.isNewImage.alpha = 1;
    }else {
        self.isNewImage.alpha = 0;
    }
    
    float angle = course.watchState.watchProgress / 100.0;
    [_halfChart addAngleValue:angle andColor:colorWithRGBA(83, 211, 230, 1)];
    [_halfChart addAngleValue:(1-angle) andColor:colorWithRGBA(233, 232, 235, 1)];
    self.progressLabel.text = [NSString stringWithFormat:@"%zd%%",(NSInteger)course.watchState.watchProgress];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.videoName.font = [UIFont systemFontOfSize:12.0];
    self.viewTotalBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.viewTotalBtn.titleLabel.textColor = colorWithRGB(153, 153, 153);
    self.videoName.textColor = colorWithRGB(81, 81, 81);
    _halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    [self.progressView addSubview:_halfChart];
    UIImageView *progressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 11, 11)];
    progressImageView.image = [UIImage imageNamed:@"course"];
    [self.progressView addSubview:progressImageView];

}

@end
