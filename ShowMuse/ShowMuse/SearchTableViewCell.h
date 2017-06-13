//
//  SearchTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/31.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

/**
 *  视频时长
 */
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
/**
 *  是否加锁
 */
@property (weak, nonatomic) IBOutlet UIImageView *isLockedToUserImage;
/**
 *  视频图片
 */
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;
/**
 *  视频标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  视频观看人数
 */
@property (weak, nonatomic) IBOutlet UIButton *viewsTotalButton;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *isNewImage;






@property (weak, nonatomic) IBOutlet UIImageView *teacherImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;


@end
