//
//  SMDownloadingVideoCell.h
//  ShowMuse
//
//  Created by ygliu on 7/27/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFDownloadManager.h>

typedef void(^SMDownloadBlock)(void);

@interface SMDownloadingVideoCell : UITableViewCell
/** model */
@property (strong, nonatomic) ZFFileModel *fileInfo;
/** request */
@property (strong, nonatomic) ZFHttpRequest *request;
/** download click */
@property (strong, nonatomic) SMDownloadBlock downloadBlock;

- (void)setVideoButtonStatusWithSelection:(BOOL)selected;

@end
