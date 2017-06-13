//
//  ShowMuseURLString.h
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ShowMuseURLString : NSObject

+ (NSString *)URLStringHost:(NSString *)path;

+ (NSString* )URLStringWithPath:(NSString* )path;


+ (NSError *)errorWithPerform:(NSError *)error;

@end
