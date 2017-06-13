//
//  SMHome_TeacherTableViewCell.m
//  ShowMuse
//
//  Created by show zh on 16/11/14.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "SMHome_TeacherTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SMHome_TeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setTeacher:(Teachers *)teacher {
    _teacher = teacher;
//    SMLog(@"/*/*/*/*/*%@",teacher.name);
    [self.teacher_headImg sd_setImageWithURL:[NSURL URLWithString:teacher.avatar] placeholderImage:[UIImage imageNamed:@"head.png"]];
    self.teacher_name.text = teacher.name;
    self.teacher_introduction.text = teacher.introduction;
    if (teacher.isBadges) {
        self.teacher_badgeImg.alpha = 1;
        [self.teacher_badgeImg sd_setImageWithURL:[NSURL URLWithString:teacher.badgeimg]];
        
    }else {
        self.teacher_badgeImg.alpha = 0;
    }
//    SMLog(@"%d/*/*/*/*/*/%@",teacher.isBadges,teacher.badgeimg);
    if (teacher.isFavourite) {
        [self.teacher_isFavouriteImg setBackgroundImage:[UIImage imageNamed:@"heart_.png"] forState:UIControlStateNormal];
    }else {
        [self.teacher_isFavouriteImg setBackgroundImage:[UIImage imageNamed:@"heart_no.png"] forState:UIControlStateNormal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
