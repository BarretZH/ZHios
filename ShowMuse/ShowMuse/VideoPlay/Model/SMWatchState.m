//
//  SMWatchState.m
//  ShowMuse
//
//  Created by liuyonggang on 31/5/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "SMWatchState.h"

@implementation SMWatchState

- (NSMutableArray *)bookmarks
{
    if (!_bookmarks) {
        _bookmarks = [NSMutableArray array];
    }
    return _bookmarks;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.bookmarks = [dict[@"bookmarks"] mutableCopy];
        self.watchProgress = [dict[@"watchProgress"] floatValue];
        self.playPosition = [dict[@"playPosition"] floatValue];
    }
    return self;
}

+ (instancetype)stateWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
