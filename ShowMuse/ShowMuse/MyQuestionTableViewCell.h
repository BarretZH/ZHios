//
//  MyQuestionTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyQusetionModel.h"
@interface MyQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *lessonButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewsTotalButton;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *isLockedToUserImage;


@property (weak, nonatomic) IBOutlet UIImageView *isNewImage;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@property (assign, nonnull) MyQusetionModel * model;
//@property (strong, nonnull) UILabel * titleLabel;

@end
