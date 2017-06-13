//
//  SMSubtitle.h
//  ShowMuse
//
//  Created by liuyonggang on 30/5/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSubtitle : NSObject

/** 字幕的编号 */
@property (assign, nonatomic) NSInteger number;

/** 结束时间 */
@property (assign, nonatomic) NSTimeInterval stopTime;

/** 开始时间 */
@property (assign, nonatomic) NSTimeInterval startTime;

/** 字幕内容 */
@property (copy, nonatomic) NSString *text;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)subtitleWithDict:(NSDictionary *)dict;

@end
