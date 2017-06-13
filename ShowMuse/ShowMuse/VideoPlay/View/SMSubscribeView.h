//
//  SMSubscribeView.h
//  ShowMuse
//
//  Created by ygliu on 8/18/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SMSubscribeBlock)();

@interface SMSubscribeView : UIView

@property (strong, nonatomic) SMSubscribeBlock tapSubscribe;

@end
