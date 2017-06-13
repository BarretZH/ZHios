//
//  SMBottomView.h
//  ShowMuse
//
//  Created by ygliu on 7/27/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMBottomViewDelegate <NSObject>

@optional
- (void)bottomViewButtonDidClick:(UIButton *)selectBtn;

@end

@interface SMBottomView : UIView
@property (weak, nonatomic) id<SMBottomViewDelegate> delegate;

@end
