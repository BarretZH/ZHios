//
//  SMTagCell.h
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMTagButton;

typedef void(^tagButtonBlock)(SMTagButton *);

typedef void(^materialButtonBlock)(SMTagButton *);

@interface SMTagCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *relatedTagsArr;

@property (strong, nonatomic) NSMutableArray *relatedMaterialArr;

@property (nonatomic,assign, readonly) CGFloat lastTagMaxY;

@property (strong, nonatomic) tagButtonBlock tagBlock;

@property (strong, nonatomic) materialButtonBlock materialBlock;

@end
