//
//  SMDownloadedCell.h
//  ShowMuse
//
//  Created by ygliu on 7/29/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFFileModel;

typedef void(^SMDownloadedBtnBlock)(void);

@interface SMDownloadedCell : UITableViewCell
/** model */
@property (strong, nonatomic) ZFFileModel *fileInfo;

@property (strong, nonatomic) SMDownloadedBtnBlock playBlock;
@end
