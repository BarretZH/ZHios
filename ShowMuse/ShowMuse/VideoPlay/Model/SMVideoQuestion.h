//
//  SMVideoQuestion.h
//  ShowMuse
//
//  Created by liuyonggang on 6/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMVideoQuestion : NSObject
/** 问题的url */
@property (copy, nonatomic) NSString *url;
/** 问题出现的时间 */
@property (assign, nonatomic) NSInteger time;

+ (instancetype)questionWithDict:(NSDictionary *)dict;
@end
