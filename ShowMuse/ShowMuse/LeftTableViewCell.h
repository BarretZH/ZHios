//
//  LeftTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/6/20.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *VIPlabel;
@property (weak, nonatomic) IBOutlet UILabel *VIPTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIImageView *messageImage;
@property (weak, nonatomic) IBOutlet UILabel *messagesLabel;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (weak, nonatomic) IBOutlet UILabel *guruLabel;


@end
