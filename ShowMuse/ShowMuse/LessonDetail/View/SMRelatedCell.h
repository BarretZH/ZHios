//
//  SMRelatedCell.h
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMRelatedCellDelegate <NSObject>
@optional
- (void)relatedCellDidClick:(NSInteger)cellIndex;

@end

@interface SMRelatedCell : UITableViewCell

@property (weak, nonatomic) id<SMRelatedCellDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *sugLessonsArr;

@property (assign, nonatomic) NSInteger commentCount;
@end
