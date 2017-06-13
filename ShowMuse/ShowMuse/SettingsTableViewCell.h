//
//  SettingsTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (weak, nonatomic) IBOutlet UIButton *quitButton;

@property (weak, nonatomic) IBOutlet UILabel *buildIDLabel;

@property (weak, nonatomic) IBOutlet UISwitch *subtitleSwitch;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *boultImage;



@end
