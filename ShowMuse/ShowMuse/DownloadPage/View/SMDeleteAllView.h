//
//  SMDeleteAllView.h
//  ShowMuse
//
//  Created by ygliu on 7/28/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMDeleteViewDelegate <NSObject>

@optional
- (void)SMDeleteViewButtonDidClick:(UIButton *)button;

@end

@interface SMDeleteAllView : UIView

@property (nonatomic,weak) id<SMDeleteViewDelegate> deleteDelegate;

@end
