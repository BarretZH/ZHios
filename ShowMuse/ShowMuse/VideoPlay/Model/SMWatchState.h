//
//  SMWatchState.h
//  ShowMuse
//
//  Created by liuyonggang on 31/5/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMWatchState : NSObject
/** bookmark数组 */
@property (strong, nonatomic) NSMutableArray *bookmarks;
/** 播放位置 */
@property (assign, nonatomic) CGFloat playPosition;
/** 观看的进度 */
@property (assign, nonatomic) CGFloat watchProgress;

+ (instancetype)stateWithDict:(NSDictionary *)dict;

@end
