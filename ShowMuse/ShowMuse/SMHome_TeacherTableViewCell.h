//
//  SMHome_TeacherTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/11/14.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "Teachers.h"

@interface SMHome_TeacherTableViewCell : UITableViewCell

@property (strong, nonatomic) Teachers * teacher;


@property (weak, nonatomic) IBOutlet UIImageView *teacher_headImg;
@property (weak, nonatomic) IBOutlet UILabel *teacher_name;
@property (weak, nonatomic) IBOutlet UILabel *teacher_introduction;
@property (weak, nonatomic) IBOutlet UIButton *teacher_isFavouriteImg;
@property (weak, nonatomic) IBOutlet UIImageView *teacher_badgeImg;
@property (weak, nonatomic) IBOutlet UIImageView *teacher_topImg;
@property (weak, nonatomic) IBOutlet UILabel *teacher_topLabel;



@end
