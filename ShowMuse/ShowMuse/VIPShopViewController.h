//
//  VIPShopViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>

@interface VIPShopViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
