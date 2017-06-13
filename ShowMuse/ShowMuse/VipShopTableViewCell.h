//
//  VipShopTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VipShopTableViewCell : UITableViewCell

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
/**
 *  RMB标识
 */
@property (weak, nonatomic) IBOutlet UILabel *RMBLabel;

/**
 *  去开通按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *gotoShopButton;



//@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end
