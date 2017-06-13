//
//  SMVideoCell.h
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMSubscribeView;

typedef void(^SMVideoCellBlock)(UIButton *);

@interface SMVideoCell : UITableViewCell

@property (weak, nonatomic, readonly) UIImageView *videoBgView;

@property (nonatomic,strong, readonly) UIButton *playView;

@property (strong, nonatomic, readonly) UIView *coverView;

@property (strong, nonatomic, readonly) SMSubscribeView *subscribe;

@property (strong, nonatomic) SMVideoCellBlock playBlock;

@end
