//
//  SMDownloadHeaderView.h
//  ShowMuse
//
//  Created by ygliu on 7/27/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMHeaderViewDelegate <NSObject>

@optional
- (void)headerViewSegmentControlDidClick:(UISegmentedControl *)pageControl;

@end

@interface SMDownloadHeaderView : UIView
/** delegate */
@property (nonatomic,weak) id<SMHeaderViewDelegate> headerViewDelegate;

@end

