//
//  QuestionTableViewCell.m
//  ShowMuse
//
//  Created by show zh on 16/5/10.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Courses.h"

@interface QuestionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *isNewImage;

@property (weak, nonatomic) IBOutlet UIButton *isNewBtn;

//@property (weak, nonatomic) IBOutlet UILabel *totalStudentsTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *studentsTitleBtn;
@end

@implementation QuestionTableViewCell

- (void)setCourse:(Courses *)course
{
    _course = course;
    [self.isNewBtn setShowsTouchWhenHighlighted:NO];
    [self.studentsTitleBtn setShowsTouchWhenHighlighted:NO];
    [self.image sd_setImageWithURL:[NSURL URLWithString:course.coverImg] placeholderImage:[UIImage imageNamed:@"pic_homes"]];
    self.titleLabel.text = course.title;
    if (course.isNew) {
        self.isNewBtn.alpha = 1;
        [self.isNewBtn setTitle:course.isNewTitle forState:UIControlStateNormal];
    }else {
        self.isNewBtn.alpha = 0;
    }
    [self.studentsTitleBtn setTitle:[NSString stringWithFormat:@" %@",course.totalStudentsTitle] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
