//
//  UserSubscriptionsTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSubscriptionsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;




@end
